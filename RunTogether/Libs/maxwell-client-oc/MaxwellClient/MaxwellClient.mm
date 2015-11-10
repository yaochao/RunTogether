//
//  MaxwellClient.m
//  MaxwellClient
//
//  Created by liuzenglu on 14/8/27.
//  Copyright (c) 2014年 liuzenglu. All rights reserved.
//

#import "MaxwellClient.h"

static NSTimeInterval CONNECT_TIMEOUT = 3;
static NSTimeInterval SEND_TIMEOUT = 3;
static NSTimeInterval RECEIVE_TIMEOUT = -1;
static NSTimeInterval SERVER_TIMEOUT = 10;

static NSInteger PROTOCOL_HEADER_LENGTH = 2;

static long SUBSCRIBE_TAG = 1;
static long PROTOCOL_HEADER_TAG = 9;
static long PROTOCOL_PAYLOAD_TAG = 7;

static uint8_t PROTOCOL_HEADER_SUBSCRIBE = 1;
static uint8_t PROTOCOL_HEADER_UNSUBSCRIBE = 2;
static uint8_t PROTOCOL_HEADER_MESSAGE = 3;

@implementation MaxwellClient

- (id)initWithEndpoint:(NSString *)endpoint
            withUserId:(NSNumber *)userId
        withSessionKey:(NSString *)sessionKey
          withListener:(RTMaxwellListener *)listener
{
    endpoint_ = endpoint;
    listener_ = listener;

    sessionId_ = new session_id_t();
    sessionId_->set_user_id([userId longLongValue]);
    sessionId_->set_session_key([sessionKey UTF8String]);

    socket_ = [[AsyncSocket alloc] initWithDelegate:self];
    subscribed_ = NO;
    timer_ = [NSTimer scheduledTimerWithTimeInterval: 2
                                     target: self
                                   selector: @selector(handleTimeout:)
                                   userInfo: nil
                                    repeats: YES];

    serverLastActive_ = [[NSDate date] timeIntervalSince1970];
    clientLastHeartbeat_ = [[NSDate date] timeIntervalSince1970];

    return self;
}



- (void)start
{
    NSURL *url = [NSURL URLWithString:endpoint_];
    NSError *error = nil;
    if (![socket_ connectToHost:[url host] onPort:[[url port] shortValue]
                   withTimeout:CONNECT_TIMEOUT error:&error]) {
        [listener_ onFailure:3 :@"connect error."];
    }
}

- (void)stop
{
    [socket_ disconnect];

    [timer_ invalidate];
    timer_ = nil;
}

- (void)dealloc
{
    delete sessionId_;
}

-(void)handleTimeout:(NSTimer *)timer
{
    if (!subscribed_) {
        return;
    }

    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (now - serverLastActive_ > SERVER_TIMEOUT) {
        [listener_ onTimeout];
        return;
    }

    [self sendHeartbeat];
}

- (void)onSocket:(AsyncSocket *)socket didConnectToHost:(NSString *)host port:(UInt16)port
{
    [self subscribe];

    [socket_ readDataToLength:PROTOCOL_HEADER_LENGTH withTimeout:RECEIVE_TIMEOUT tag:PROTOCOL_HEADER_TAG];
}

- (void)onSocket:(AsyncSocket *)socket didWriteDataWithTag:(long)tag
{
    if (tag == SUBSCRIBE_TAG && !subscribed_) {
        subscribed_ = YES;
    }
}

- (void)onSocket:(AsyncSocket *)socket didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == PROTOCOL_HEADER_TAG) {
        uint16_t size = [self to_int:(uint8_t *)[data bytes]];
        [socket_ readDataToLength:size withTimeout:RECEIVE_TIMEOUT tag:PROTOCOL_PAYLOAD_TAG];
    } else if (tag == PROTOCOL_PAYLOAD_TAG) {
        uint8_t type = ((uint8_t *)[data bytes])[0];
        // NSLog(@"---------------------------------------------------------got pub from server, type = %d, data length = %d", type, [data length]);

        [self updateServerLastActiveTime];

        switch (type) {
            case SERVER_HEARTBEAT:
            {
                // do nothing.
            }
                break;

            case MSG:
            {
                msg_t v;
                v.ParseFromArray((uint8_t *)[data bytes] + 1, [data length] - 1);
                [self handleMessage:&v];
            }
                break;

            case MSGS:
            {
                msgs_t v;
                v.ParseFromArray((uint8_t *)[data bytes] + 1, [data length] - 1);
                [self handleManyMessages:&v];
            }

            default:
                [listener_ onFailure:1 :[NSString stringWithFormat:@"bad pub type: %d.", type]];
                break;
        }

        [socket_ readDataToLength:PROTOCOL_HEADER_LENGTH withTimeout:RECEIVE_TIMEOUT tag:PROTOCOL_HEADER_TAG];
    } else {
        [listener_ onFailure:2 :@"protocol error."];
    }
}

- (void)subscribe
{
    subscribe_t v;
    v.mutable_session_id()->CopyFrom(*sessionId_);
    [self writeMessage:&v withProtocolType:PROTOCOL_HEADER_SUBSCRIBE withSubscribeType:SUBSCRIBE withTag:SUBSCRIBE_TAG];
}

- (void)unsubscribe
{
    unsubscribe_t v;
    v.mutable_session_id()->CopyFrom(*sessionId_);
    [self writeMessage:&v withProtocolType:PROTOCOL_HEADER_UNSUBSCRIBE withSubscribeType:UNSUBSCRIBE];
}

- (void)ack:(uint64_t)v
{
    uint64_t arr[1] = {v};
    return [self ackMany:arr withLength:1];
}

- (void)ackMany:(uint64_t *)arr withLength:(NSUInteger)len
{
    ack_t v;
    for (int i = 0; i < len; i++) {
        v.add_msg_ids(arr[i]);
    }
    [self writeMessage:&v withProtocolType:PROTOCOL_HEADER_MESSAGE withSubscribeType:ACK];
}

- (void)sendHeartbeat
{
    client_heartbeat_t v;
    [self writeMessage:&v withProtocolType:PROTOCOL_HEADER_MESSAGE withSubscribeType:CLIENT_HEARTBEAT];
}

- (void)updateServerLastActiveTime
{
    serverLastActive_ = [[NSDate date] timeIntervalSince1970];
}

- (void)handleMessage:(msg_t *)v
{

        __block SessionId *sessionId = new SessionId;
        sessionId->userId = [[NSNumber alloc] initWithLongLong:sessionId_->user_id()];
        sessionId->sessionKey = [NSString stringWithCString:sessionId_->session_key().c_str()
                                                   encoding:[NSString defaultCStringEncoding]];

        __block MaxwellMessage *message = new MaxwellMessage;
        message->_id = [[NSNumber alloc] initWithLongLong:v->id()];
        message->payload = [NSString stringWithCString:v->payload().c_str()
                                              encoding:[NSString defaultCStringEncoding]];
        message->dateAdded = [[NSNumber alloc] initWithInt:v->date_added()];
    dispatch_async(dispatch_get_main_queue(), ^{
        [listener_ onMessage:sessionId :message];
    });


    [self ack:v->id()];
}

- (void)handleManyMessages:(msgs_t *)v
{
    uint64_t ids[v->msgs_size()];

    SessionId *sessionId = new SessionId;
    sessionId->userId = [[NSNumber alloc] initWithLongLong:sessionId_->user_id()];
    sessionId->sessionKey = [NSString stringWithCString:sessionId_->session_key().c_str()
                                               encoding:[NSString defaultCStringEncoding]];
    for (int i = 0; i < v->msgs_size(); i++) {
        ids[i] = v->msgs(i).id();

        MaxwellMessage *message = new MaxwellMessage;
        message->_id = [[NSNumber alloc] initWithLongLong:v->msgs(i).id()];
        message->payload = [NSString stringWithCString:v->msgs(i).payload().c_str()
                                              encoding:[NSString defaultCStringEncoding]];
        message->dateAdded = [[NSNumber alloc] initWithInt:v->msgs(i).date_added()];

        [listener_ onMessage:sessionId :message];
    }

    [self ackMany:ids withLength:v->msgs_size()];
}

- (void)writeMessage:(MessageLite *)message
    withProtocolType:(uint8_t)protocolType
   withSubscribeType:(uint8_t)subscribeType
{
    [self writeMessage:message withProtocolType:protocolType withSubscribeType:subscribeType withTag:0];
}

- (void)writeMessage:(MessageLite *)message
    withProtocolType:(uint8_t)protocolType
     withSubscribeType:(uint8_t)subscribeType
             withTag:(long)tag
{
    NSUInteger serializedSize = message->ByteSize();

    uint8_t protocolHeaderArray[PROTOCOL_HEADER_LENGTH];
    [self to_bytes:serializedSize + 2 :protocolHeaderArray];

    uint8_t protocolTypeArray[1];
    protocolTypeArray[0] = protocolType;

    uint8_t subscribeHeaderArray[1];
    subscribeHeaderArray[0] = subscribeType;

    uint8_t serializedData[serializedSize];
    message->SerializeToArray(serializedData, serializedSize);

    NSMutableData *data = [[NSMutableData alloc] initWithCapacity:serializedSize + 4];

    [data appendData:[[NSData alloc] initWithBytesNoCopy:protocolHeaderArray length:PROTOCOL_HEADER_LENGTH freeWhenDone:NO]];
    [data appendData:[[NSData alloc] initWithBytesNoCopy:protocolTypeArray length:1 freeWhenDone:NO]];
    [data appendData:[[NSData alloc] initWithBytesNoCopy:subscribeHeaderArray length:1 freeWhenDone:NO]];
    [data appendData:[[NSData alloc] initWithBytesNoCopy:serializedData length:serializedSize freeWhenDone:NO]];

    [socket_ writeData:data withTimeout:SEND_TIMEOUT tag:tag];
}

- (uint16_t) to_int:(uint8_t*) v
{
    return (v[0] << 8) + v[1];
}

- (void) to_bytes:(uint16_t) i :(uint8_t*) v
{
    v[0] = (i >> 8) & 0xFF;
    v[1] = (i & 0xFF);
}

@end

//
//  MaxwellClient.h
//  MaxwellClient
//
//  Created by liuzenglu on 14/8/27.
//  Copyright (c) 2014年 liuzenglu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
#import "RTMaxwellListener.h"

#include "common_structs.pb.h"
#include "subscriber_publisher_structs.pb.h"
#include "subscriber_publisher.pb.h"

using namespace maxwell::protocol;
using namespace google::protobuf;




@protocol MessageboxListener <NSObject>

- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message;

- (void) onTimeout;

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage;

@end


@interface MaxwellClient : NSObject
{
    NSString *endpoint_;
    RTMaxwellListener *listener_;
    
    session_id_t *sessionId_;

    NSTimer *timer_;
    AsyncSocket *socket_;
    BOOL subscribed_;

    NSTimeInterval serverLastActive_;
    NSTimeInterval clientLastHeartbeat_;
}

- (id)initWithEndpoint:(NSString *)endpoint
            withUserId:(NSNumber *)userId
        withSessionKey:(NSString *)sessionKey
          withListener:(RTMaxwellListener *)listener;

- (void)start;

- (void)stop;

- (void)dealloc;

@end

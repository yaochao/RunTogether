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



// 监听器协议
//@protocol Listener <NSObject>
//
//@required
//- (id) initWithMessageBox : (NSObject *) messagebox;
//
//- (void) onMessage:(SessionId *)sessionId
//                  :(MaxwellMessage *)message;
//
//- (void) onTimeout;
//
//- (void) onFailure:(int)errorCode
//                  :(NSString *)errorMessage;
//
//@end

//@interface Listener : NSObject
//
//@property(nonatomic,retain) NSObject *maxwellClient;
//
//- (id) initWithMessageBox : (NSObject *) messagebox;
//
//- (void) onMessage:(SessionId *)sessionId
//                  :(MaxwellMessage *)message;
//
//- (void) onTimeout;
//
//- (void) onFailure:(int)errorCode
//                  :(NSString *)errorMessage;
//
//@end

@protocol MessageboxListener <NSObject>

- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message;

- (void) onTimeout;

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage;

@end

//simply clone a listener using SF- prefix for SFMessage refactor. Two listers would work at the same time
@interface SFListener : NSObject

@property(nonatomic,retain) NSObject *maxwellClient;

- (id) initWithMessageBox : (NSObject *) messagebox;

- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message;

- (void) onTimeout;

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage;

@end

@protocol SFMessageboxListener <NSObject>

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
    
    //临时增加，供重构期间使用，重构完成后替换Listener
    SFListener *SFlistener_;
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

- (id)initWithEndpoint:(NSString *)endpoint
            withUserId:(NSNumber *)userId
        withSessionKey:(NSString *)sessionKey
          withSFListener:(SFListener *)SFlistener;

- (void)start;

- (void)stop;

- (void)dealloc;

@end

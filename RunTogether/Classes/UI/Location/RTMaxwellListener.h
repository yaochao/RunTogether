//
//  RTMaxwellListener.h
//  RunTogether
//
//  Created by yaochao on 15/11/9.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

struct SessionId
{
    NSNumber *userId;
    NSString *sessionKey;
};

struct MaxwellMessage
{
    NSNumber *_id;
    NSString *payload;
    NSNumber * dateAdded;
};


@interface RTMaxwellListener : NSObject
@property(nonatomic,retain) NSObject *maxwellClient;


- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message;

- (void) onTimeout;

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage;


@end

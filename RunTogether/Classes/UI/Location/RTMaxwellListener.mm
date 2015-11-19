//
//  RTMaxwellListener.m
//  RunTogether
//
//  Created by yaochao on 15/11/9.
//  Copyright © 2015年 duoduo. All rights reserved.
//


#import "RTMaxwellListener.h"
#import "MBProgressHUD+MJ.h"

@implementation RTMaxwellListener

// 每次推送会调用3次这个方法
- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message {
    NSLog(@"Listener - 收到了推送 %@", message->payload);
    // 字符串转字典
    NSData *data = [message->payload dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    switch ([dict[@"type"] integerValue]) {
        case USER_LOCATION_CREATED:
            [RTNotificationCenter postNotificationName:RTLocationCreatedNotification object:nil userInfo:@{RTLocationCreatedKey : dict}];
            break;
        case TYPE_GAME_STARTED:
            [RTNotificationCenter postNotificationName:RTGameStartedNotification object:nil userInfo:@{RTGameStartedKey : dict}];
            break;
        case TYPE_GAME_OVER:
            [RTNotificationCenter postNotificationName:RTGameOverNotification object:nil userInfo:@{RTGameOverKey : dict}];
            break;
        case TYPE_GAME_RANK_CHANGED:
            [RTNotificationCenter postNotificationName:RTGameRankChangedNotification object:nil userInfo:@{RTGameRankChangedKey : dict}];
            break;
        default:
            break;
    }
}

// 当Maxwell超时的时候调用的方法
- (void) onTimeout {
    NSLog(@"Listener - onTimeout");
    [RTNotificationCenter postNotificationName:@"MaxwellTimeoutNotification" object:nil];
}

// Failure
- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage {
    NSLog(@"Listener - onFailure,%@", errorMessage);
    [RTNotificationCenter postNotificationName:@"MaxwellFailureNotification" object:nil];
    
}


@end

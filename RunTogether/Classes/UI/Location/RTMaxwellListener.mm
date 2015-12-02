//
//  RTMaxwellListener.m
//  RunTogether
//
//  Created by yaochao on 15/11/9.
//  Copyright © 2015年 duoduo. All rights reserved.
//


#import "RTMaxwellListener.h"
#import "MBProgressHUD+MJ.h"
#import "RTGameStartedBodyModel.h"
#import "RTLocationCreateBodyModel.h"
#import "RTGameOverBodyModel.h"
#import "RTGameRankChangedBodyModel.h"
#import "RTGameDistanceChangedBodyModel.h"
#import <MJExtension/MJExtension.h>

@implementation RTMaxwellListener


- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message {
    // 字符串转字典
    NSData *data = [message->payload dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    switch ([dict[@"type"] integerValue]) {
        case USER_LOCATION_CREATED:
            [RTNotificationCenter postNotificationName:RTLocationCreatedNotification object:nil userInfo:@{RTLocationCreatedKey : [RTLocationCreateBodyModel objectWithKeyValues:dict[@"body"]]}];
            NSLog(@"Listener - 收到了位置更新的推送 %@", message->payload);
            break;
        case TYPE_GAME_STARTED:
            [RTNotificationCenter postNotificationName:RTGameStartedNotification object:nil userInfo:@{RTGameStartedKey : [RTGameStartedBodyModel objectWithKeyValues:dict[@"body"]]}];
            NSLog(@"Listener - 收到了游戏开始的推送 %@", message->payload);
            break;
        case TYPE_GAME_OVER:
            [RTNotificationCenter postNotificationName:RTGameOverNotification object:nil userInfo:@{RTGameOverKey : [RTGameOverBodyModel objectWithKeyValues:dict[@"body"]]}];
            NSLog(@"Listener - 收到了游戏结束的推送 %@", message->payload);
            break;
        case TYPE_GAME_DISTANCE_CHANGED:
            [RTNotificationCenter postNotificationName:RTGameDistanceChangedNotification object:nil userInfo:@{RTGameDistanceChangedKey : [RTGameDistanceChangedBodyModel objectWithKeyValues:dict[@"body"]]}];
            NSLog(@"Listener - 收到了距离改变的推送 %@", message->payload);
            break;
        case TYPE_GAME_RANK_CHANGED:
            [RTNotificationCenter postNotificationName:RTGameRankChangedNotification object:nil userInfo:@{RTGameRankChangedKey : [RTGameRankChangedBodyModel objectWithKeyValues:dict[@"body"]]}];
            NSLog(@"Listener - 收到了排名改变的推送 %@", message->payload);
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

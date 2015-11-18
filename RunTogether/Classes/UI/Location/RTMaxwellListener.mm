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

            break;
        case TYPE_GAME_STARTED:
            
            break;
        case TYPE_GAME_OVER:
            
            break;
        case TYPE_GAME_RANK_CHANGED:
            
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

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage {
    NSLog(@"Listener - onFailure,%@", errorMessage);
    [RTNotificationCenter postNotificationName:@"MaxwellFailureNotification" object:nil];
    
}


@end

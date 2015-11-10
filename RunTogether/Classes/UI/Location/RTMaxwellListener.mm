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
    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"收到了推送 - %@", message->payload]];
}

// 当Maxwell超时的时候调用的方法
- (void) onTimeout {
    NSLog(@"Listener - onTimeout");


}

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage {
    NSLog(@"Listener - onFailure,%@", errorMessage);
}


@end

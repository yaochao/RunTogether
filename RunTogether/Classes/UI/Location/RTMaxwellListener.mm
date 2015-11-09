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


- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message {
    NSLog(@"Listener - 收到了推送 %@", message->payload);
    [MBProgressHUD showSuccess:[NSString stringWithFormat:@"收到了推送 - %@", message->payload]];
}

- (void) onTimeout {
    NSLog(@"Listener - onTimeout");
}

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage {
    NSLog(@"Listener - onFailure,%@", errorMessage);
}


@end

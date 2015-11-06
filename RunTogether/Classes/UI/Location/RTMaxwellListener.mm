//
//  RTMaxwellListener.m
//  RunTogether
//
//  Created by yaochao on 15/11/6.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTMaxwellListener.h"

@implementation RTMaxwellListener

// 收到消息的回调
- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message {
    
}

- (void) onTimeout {

}

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage {
    
}
@end

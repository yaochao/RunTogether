//
//  RTMaxwellListener.h
//  RunTogether
//
//  Created by yaochao on 15/11/8.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "MaxwellClient.h"

@interface RTMaxwellListener: Listener

- (void) onMessage:(SessionId *)sessionId
                  :(MaxwellMessage *)message;

- (void) onTimeout;

- (void) onFailure:(int)errorCode
                  :(NSString *)errorMessage;

@end

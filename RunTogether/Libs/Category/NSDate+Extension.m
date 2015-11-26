//
//  NSDate+Extension.m
//  RunTogether
//
//  Created by yaochao on 15/11/26.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

- (NSString *)stringFromDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-ddTHH:mm:ssZ";
    return [formatter stringFromDate:<#(nonnull NSDate *)#>:self];
}

@end

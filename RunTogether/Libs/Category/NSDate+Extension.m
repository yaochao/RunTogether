//
//  NSDate+Extension.m
//  RunTogether
//
//  Created by yaochao on 15/11/26.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "NSDate+Extension.h"
#import "NSString+Extension.h"

@implementation NSDate (Extension)

- (NSString *)stringFromDate {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-ddTHH:mm:ssZ";
    return [formatter stringFromDate:self];
}

+ (NSString *)timeIntervalWithDateStr1:(NSString *)dateStr1 dateStr2:(NSString *)dateStr2 {
    NSDate *date1 = [dateStr1 dateFromString];
    NSDate *date2 = [dateStr2 dateFromString];
    NSTimeInterval interval1 = [date1 timeIntervalSince1970];
    NSTimeInterval interval2 = [date2 timeIntervalSince1970];
    // 差的毫秒数
    NSTimeInterval result = (interval2 - interval1) < 0 ? (interval2 - interval1) * -1 : (interval2 - interval1);
    // 秒数
    return [NSString stringWithFormat:@"%f", result/1000];
}

@end
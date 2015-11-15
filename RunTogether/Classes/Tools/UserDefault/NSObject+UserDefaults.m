//
//  NSObject+UserDefaults.m
//  RunTogether
//
//  Created by yaochao on 15/11/15.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "NSObject+UserDefaults.h"
#import "RTUserDefaultManager.h"
@implementation NSObject (UserDefaults)

- (void)saveValueWithKey:(NSString *)key {
    [[RTUserDefaultManager sharedUserDefaultManager] saveValue:self withKey:key];
}

+ (id)getValueWithKey:(NSString *)key {
    return [[RTUserDefaultManager sharedUserDefaultManager] getValeWithKey:key];
}


@end

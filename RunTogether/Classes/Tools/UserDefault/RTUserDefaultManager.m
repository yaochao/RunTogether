//
//  RTUserDefaultManager.m
//  RunTogether
//
//  Created by yaochao on 15/11/15.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTUserDefaultManager.h"
#import <FastCoding/FastCoder.h>

@implementation RTUserDefaultManager

/**
 *  得到单例对象
 *
 *  @return 单例对象
 */
+ (instancetype)sharedUserDefaultManager {
    
    static RTUserDefaultManager *userDefaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userDefaultManager = [[RTUserDefaultManager alloc] init];
    });
    return userDefaultManager;
}

/**
 *  存储
 *
 *  @param value value
 *  @param key   key
 */
- (void)saveValue:(id)value withKey:(NSString *)key {
    
    // 断言，如果为nil，就崩溃 (防止传入nil)
    NSParameterAssert(value);
    NSParameterAssert(key);
    
    NSData *data = [FastCoder dataWithRootObject:value];
    if (data) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


/**
 *  取值
 *
 *  @param key 键
 *  @return value
 */
- (id)getValeWithKey:(NSString *)key {
    NSParameterAssert(key);
    NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return [FastCoder objectWithData:data];
}

@end

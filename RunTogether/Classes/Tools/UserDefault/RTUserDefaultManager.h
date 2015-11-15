//
//  RTUserDefaultManager.h
//  RunTogether
//
//  Created by yaochao on 15/11/15.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTUserDefaultManager : NSObject

/**
 *  得到单例对象
 *
 *  @return 单例对象
 */

+ (instancetype)sharedUserDefaultManager;

/**
 *  存储
 *
 *  @param value value
 *  @param key   key
 */
- (void)saveValue:(id)value withKey:(NSString *)key;

/**
 *  取值
 *
 *  @param key 键
 *
 *  @return value
 */
- (id)getValeWithKey:(NSString *)key;


@end

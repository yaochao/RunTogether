//
//  NSObject+UserDefaults.h
//  RunTogether
//
//  Created by yaochao on 15/11/15.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (UserDefaults)

/**
 *  @author yaochao
 *
 *  对UserDefaultManager的进一步封装
 */

- (void)saveValueWithKey:(NSString *)key;

+ (id)getValueWithKey:(NSString *)key;

+ (void)removeAll;

+ (void)removeValueWithKey:(NSString *)key;



@end

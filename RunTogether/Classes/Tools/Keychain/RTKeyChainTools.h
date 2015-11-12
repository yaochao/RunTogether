//
//  RTKeyChainTools.h
//  RunTogether
//
//  Created by yaochao on 15/11/4.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTKeyChainTools : NSObject

// 存储
+ (BOOL)saveRememberToken:(NSString *)remember_token;
+ (BOOL)saveUserId:(NSString *)user_id;
+ (BOOL)saveSessionKey:(NSString *)session_key;
+ (BOOL)savePhone:(NSString *)phone;
+ (BOOL)saveEndpoint:(NSString *)endpoint;
+ (BOOL)saveLastNetworkReachabilityStatus:(NSString *)networkReachabilityStatus;

// 读取
+ (NSString *)getRememberToken;
+ (NSString *)getUserId;
+ (NSString *)getSessionKey;
+ (NSString *)getPhone;
+ (NSString *)getEndpoint;
+ (NSString *)getLastNetworkReachabilityStatus;

// 删除
+ (BOOL)removeRememberToken;
+ (BOOL)removeUserId;
+ (BOOL)removeSessionKey;
+ (BOOL)removePhone;
+ (BOOL)removeEndpoint;
+ (BOOL)removeLastNetworkReachabilityStatus;


@end

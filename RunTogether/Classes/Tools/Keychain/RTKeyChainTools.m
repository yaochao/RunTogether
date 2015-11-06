//
//  RTKeyChainTools.m
//  RunTogether
//
//  Created by yaochao on 15/11/4.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTKeyChainTools.h"
#import "RTKeyChainSingleton.h"


@implementation RTKeyChainTools

// 存储
+ (BOOL)saveRememberToken:(NSString *)remember_token {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] setString:remember_token forKey:@"remember_token"];
}

+ (BOOL)saveUserId:(NSString *)user_id {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] setString:user_id forKey:@"user_id"];
}

+ (BOOL)saveSessionKey:(NSString *)session_key {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] setString:session_key forKey:@"session_key"];
}

+ (BOOL)savePhone:(NSString *)phone {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] setString:phone forKey:@"phone"];
}

+ (BOOL)saveEndpoint:(NSString *)endpoint {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] setString:endpoint forKey:@"endpoint"];
}


// 读取
+ (NSString *)getRememberToken {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] stringForKey:@"remember_token"];
}

+ (NSString *)getUserId {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] stringForKey:@"user_id"];
}

+ (NSString *)getSessionKey {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] stringForKey:@"session_key"];
}

+ (NSString *)getPhone {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] stringForKey:@"phone"];
}

+ (NSString *)getEndpoint {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] stringForKey:@"endpoint"];
}


// 删除
+ (BOOL)removeRememberToken {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] removeItemForKey:@"remember_token"];
}

+ (BOOL)removeUserId {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] removeItemForKey:@"user_id"];
}

+ (BOOL)removeSessionKey {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] removeItemForKey:@"session_key"];
}

+ (BOOL)removePhone {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] removeItemForKey:@"phone"];
}

+ (BOOL)removeEndpoint {
    return [[RTKeyChainSingleton sharedKeyChainSingleton] removeItemForKey:@"endpoint"];
}

@end

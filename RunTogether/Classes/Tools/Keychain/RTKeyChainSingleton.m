//
//  RTKeyChainSingleton.m
//  RunTogether
//
//  Created by yaochao on 15/11/4.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTKeyChainSingleton.h"

@implementation RTKeyChainSingleton

+ (instancetype)sharedKeyChainSingleton {
    static id keyChainSingleton;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        keyChainSingleton = [RTKeyChainSingleton keyChainStoreWithService:@"com.duoduosports.userInfo"];
    });
    return keyChainSingleton;
}

@end

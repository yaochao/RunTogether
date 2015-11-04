//
//  RTKeyChainSingleton.h
//  RunTogether
//
//  Created by yaochao on 15/11/4.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <UICKeyChainStore/UICKeyChainStore.h>

@interface RTKeyChainSingleton : UICKeyChainStore

// 获得单例
+ (instancetype)sharedKeyChainSingleton;


@end

//
//  RTHTTPSessionManager.m
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import "RTHTTPSessionManager.h"

@implementation RTHTTPSessionManager

// 单例
+ (instancetype)sharedNetworkManager {
    static RTHTTPSessionManager *tools;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tools = [[RTHTTPSessionManager alloc] init];
        
        // 设置反序列化的数据格式－> 官方建议的修改方式
        tools.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    });
    return tools;
}

@end

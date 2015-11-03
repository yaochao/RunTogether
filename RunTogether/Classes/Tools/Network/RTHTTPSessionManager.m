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
    static RTHTTPSessionManager *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [RTHTTPSessionManager manager];
        
        // 设置反序列化的数据格式－> 官方建议的修改方式
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
        
        // 设置安全策略，忽略签名证书，SSL
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"rt" ofType:@"der"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        [securityPolicy setAllowInvalidCertificates:YES];
        [securityPolicy setValidatesDomainName:NO];
        [securityPolicy setPinnedCertificates:@[certData]];
        manager.securityPolicy = securityPolicy;
    });
    return manager;
}

@end

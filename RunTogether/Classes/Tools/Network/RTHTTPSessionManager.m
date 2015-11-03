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
        
        // 设置安全策略，关于自制的签名证书，SSL
        // 方式一：证书绑定方式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.allowInvalidCertificates = YES;
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"rt" ofType:@"der"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        [securityPolicy setPinnedCertificates:@[certData]];
        manager.securityPolicy = securityPolicy;
        // 方式二：直接忽略，会遭到中间人攻击的危险(建议方式一)
//        manager.securityPolicy.allowInvalidCertificates = YES;
//        manager.securityPolicy.validatesDomainName = NO;
        
        
    });
    return manager;
}

@end

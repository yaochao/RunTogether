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
        // manager.securityPolicy.allowInvalidCertificates = YES;
        // manager.securityPolicy.validatesDomainName = NO;
        
        
    });
    return manager;
}

/// This wraps the completion handler with a shim that injects the responseObject into the error.
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *, id, NSError *))originalCompletionHandler {
    return [super dataTaskWithRequest:request
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        
                        // If there's an error, store the response in it if we've got one.
                        if (error && responseObject) {
                            if (error.userInfo) { // Already has a dictionary, so we need to add to it.
                                NSMutableDictionary *userInfo = [error.userInfo mutableCopy];
                                userInfo[kErrorResponseObjectKey] = responseObject;
                                error = [NSError errorWithDomain:error.domain
                                                            code:error.code
                                                        userInfo:[userInfo copy]];
                            } else { // No dictionary, make a new one.
                                error = [NSError errorWithDomain:error.domain
                                                            code:error.code
                                                        userInfo:@{kErrorResponseObjectKey: responseObject}];
                            }
                        }
                        
                        // Call the original handler.
                        if (originalCompletionHandler) {
                            originalCompletionHandler(response, responseObject, error);
                        }
                    }];
}

@end

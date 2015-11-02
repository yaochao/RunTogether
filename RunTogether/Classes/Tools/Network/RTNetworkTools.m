//
//  RTNetworkTools.m
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import "RTNetworkTools.h"
#import "RTHTTPSessionManager.h"

@implementation RTNetworkTools

#pragma mark - POST 加载网络数据
+ (void)postDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType completionBlock:(void (^)(id responseObject))completionBlock{
    
    // 获得网络管理单例对象
    RTHTTPSessionManager *manager = [RTHTTPSessionManager sharedNetworkManager];
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    // 打印一下请求的地址
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@", BaseUrl, interfaceType];
    NSLog(@"请求的网络地址 - %@", completeUrl);
    
    // 发送POST请求
    [manager POST:completeUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"网络错误 - %@", error);
        // 提示网络有问题
        NSString *errorMsg = [NSString stringWithFormat:@"请检查您的网络连接\n错误代码 %li", error.code];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
}


#pragma mark - POST 加载网络数据
+ (void)getDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType completionBlock:(void (^)(id responseObject))completionBlock{
    
    // 获得网络管理单例对象
    RTHTTPSessionManager *manager = [RTHTTPSessionManager sharedNetworkManager];
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    // 打印一下请求的地址
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@", BaseUrl, interfaceType];
    NSLog(@"请求的网络地址 - %@", completeUrl);
    
    // 发送POST请求
    [manager GET:completeUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        completionBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"网络错误 - %@", error);
        // 提示网络有问题
        NSString *errorMsg = [NSString stringWithFormat:@"请检查您的网络连接\n错误代码 %li", error.code];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
    
}

@end

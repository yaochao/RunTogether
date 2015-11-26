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
+ (void)postDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {

    // 获得网络管理单例对象
    RTHTTPSessionManager *manager = [RTHTTPSessionManager sharedNetworkManager];
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    // 打印一下请求的地址
    NSString *completeUrl = [BaseUrl stringByAppendingPathComponent:interfaceType];
    NSLog(@"请求的网络地址 - %@", completeUrl);
    
    // 发送POST请求
    [manager POST:completeUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}


#pragma mark - GET 加载网络数据
+ (void)getDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    // 获得网络管理单例对象
    RTHTTPSessionManager *manager = [RTHTTPSessionManager sharedNetworkManager];
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    // 打印一下请求的地址
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@", BaseUrl, interfaceType];
    NSLog(@"请求的网络地址 - %@", completeUrl);
    
    // 发送GET请求
    [manager GET:completeUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
    
}

#pragma mark - DELETE 加载网络数据
+ (void)deleteDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    // 获得网络管理单例对象
    RTHTTPSessionManager *manager = [RTHTTPSessionManager sharedNetworkManager];
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    // 打印一下请求的地址
    NSString *completeUrl = [BaseUrl stringByAppendingPathComponent:interfaceType];
    NSLog(@"请求的网络地址 - %@", completeUrl);
    
    // 发送DELETE请求
    [manager DELETE:completeUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}


#pragma mark - POST 加载网络数据
+ (void)patchDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    // 获得网络管理单例对象
    RTHTTPSessionManager *manager = [RTHTTPSessionManager sharedNetworkManager];
    if (params == nil) {
        params = [NSMutableDictionary dictionary];
    }
    
    // 打印一下请求的地址
    NSString *completeUrl = [BaseUrl stringByAppendingPathComponent:interfaceType];
    NSLog(@"请求的网络地址 - %@", completeUrl);
    
    // 发送PATCH请求
    [manager PATCH:completeUrl parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}


#pragma mark - 保存cookies和加载cookies和删除cookies

+ (void)saveCookies{
    
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
    NSLog(@"----------%lu",[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies].count);
    
}

+ (void)loadCookies{
    
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
        NSLog(@"----------%@", cookie);
    }
    
    
}

+ (void)deleteCookies {
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *_tmpArray = [NSArray arrayWithArray:[cookieJar cookies]];
    for (id obj in _tmpArray) {
        [cookieJar deleteCookie:obj];
    }
    NSLog(@"cookie个数 - %li",[[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies] count]);
}


@end

//
//  RTHTTPSessionManager.h
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import <AFNetworking/AFHTTPSessionManager.h>

@interface RTHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedNetworkManager;

@end

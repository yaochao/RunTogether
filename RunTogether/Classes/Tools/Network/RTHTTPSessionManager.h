//
//  RTHTTPSessionManager.h
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import <AFNetworking/AFNetworking.h>

@interface RTHTTPSessionManager : AFHTTPSessionManager

+ (instancetype)sharedNetworkManager;

@end

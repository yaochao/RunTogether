//
//  RTNetworkTools.h
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import <UIKit/UIKit.h>

@interface RTNetworkTools : NSObject

// POST请求
+ (void)postDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

// GET请求
+ (void)getDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

@end

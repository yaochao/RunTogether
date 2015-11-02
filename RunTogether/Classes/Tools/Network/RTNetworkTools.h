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
+ (void)postDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType completionBlock:(void (^)(id responseObject))completionBlock;

// GET请求
+ (void)getDataWithParams:(NSMutableDictionary *)params interfaceType:(NSString *)interfaceType completionBlock:(void (^)(id responseObject))completionBlock;

@end

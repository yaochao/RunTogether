//
//  RTLoginModel.h
//  RunTogether
//
//  Created by 赵欢 on 15/11/27.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTLoginModel : NSObject

@property (nonatomic, strong) NSString *maxwell_endpoint;
@property (nonatomic, strong) NSString *remember_token;
@property (nonatomic, strong) NSString *session_key;
@property (nonatomic, strong) NSString *user_id;

@end

//
//  RTGamePropertiesModel.h
//  RunTogether
//
//  Created by 赵欢 on 15/11/25.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTGamePropertiesModel : NSObject

@property (nonatomic, assign) NSInteger queuing_users_before_me;
@property (nonatomic, assign) NSInteger queuing_users_after_me;
@property (nonatomic, assign) NSInteger total_distance;
@property (nonatomic, assign) NSInteger game_count;
@property (nonatomic, assign) NSInteger mean_velocity;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger medal;
@property (nonatomic, strong) NSString *banned_until;

@end

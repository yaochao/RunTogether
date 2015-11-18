//
//  RTGameRankChangedBodyModel.m
//  RunTogether
//
//  Created by yaochao on 15/11/18.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTGameRankChangedBodyModel.h"

@implementation RTGameRankChangedBodyModel

// mapping
+ (NSDictionary *)objectClassInArray
{
    return @{
             @"rank" : @"RTGameOverBodyRankModel",
             @"last_rank" : @"RTGameOverBodyRankModel"
             };
}


@end

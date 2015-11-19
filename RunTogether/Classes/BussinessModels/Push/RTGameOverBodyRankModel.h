//
//  RTGameOverBodyRankModel.h
//  RunTogether
//
//  Created by yaochao on 15/11/18.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTGameStartedBodyUsersModel.h"

@interface RTGameOverBodyRankModel : NSObject

@property (nonatomic, strong) NSString *distance;
@property (nonatomic, strong) RTGameStartedBodyUsersModel *user;

@end

//
//  RTMyHistoryModel.h
//  RunTogether
//
//  Created by yaochao on 15/11/26.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTGameModel.h"
#import "RTResultModel.h"

@interface RTMyHistoryModel : NSObject

@property (nonatomic, strong) RTGameModel *game;
@property (nonatomic, strong) RTResultModel *result;

@end

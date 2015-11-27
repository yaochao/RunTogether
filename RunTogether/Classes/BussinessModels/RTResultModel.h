//
//  RTResultModel.h
//  RunTogether
//
//  Created by yaochao on 15/11/26.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTResultItemModel.h"

@interface RTResultModel : NSObject

@property (nonatomic, copy) RTResultItemModel *item;
@property (nonatomic, copy) NSString *rank;

@end

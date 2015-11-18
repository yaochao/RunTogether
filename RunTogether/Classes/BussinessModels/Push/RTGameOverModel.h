//
//  RTGameOverModel.h
//  RunTogether
//
//  Created by yaochao on 15/11/18.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RTGameOverBodyModel.h"

@interface RTGameOverModel : NSObject

@property (nonatomic, strong) RTGameOverBodyModel *body;
@property (nonatomic, strong) NSString *date_added;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *type;


@end

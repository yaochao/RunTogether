//
//  RTPlayerCell.h
//  RunTogether
//
//  Created by yaochao on 15/11/19.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTGameStartedBodyUsersModel.h"

@interface RTPlayerCell : UITableViewCell
// 模型
@property (nonatomic, strong) RTGameStartedBodyUsersModel *userModel;
// 排名让上一级赋值，根据cell的row
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@end

//
//  RTPlayerCell.m
//  RunTogether
//
//  Created by yaochao on 15/11/19.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTPlayerCell.h"

@interface RTPlayerCell ()


@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *useridLbl;

@end

@implementation RTPlayerCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setUserModel:(RTGameStartedBodyUsersModel *)userModel {
    _userModel = userModel;
    // 赋值
    self.usernameLbl.text = userModel.name == nil ? @"Hello" : userModel.name;
    self.useridLbl.text = userModel.id == nil ? @"4000000" : userModel.id;
}

@end

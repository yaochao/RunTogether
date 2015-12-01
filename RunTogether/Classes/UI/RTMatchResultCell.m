//
//  RTMatchResultCell.m
//  RunTogether
//
//  Created by yaochao on 15/12/1.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTMatchResultCell.h"

@interface RTMatchResultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@end

@implementation RTMatchResultCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

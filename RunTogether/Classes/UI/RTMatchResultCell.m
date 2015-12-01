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
    self.headerImgView.layer.cornerRadius = self.headerImgView.frame.size.width / 2;
    self.headerImgView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

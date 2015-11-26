//
//  RTMyHistoryCell.m
//  RunTogether
//
//  Created by yaochao on 15/11/25.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTMyHistoryCell.h"
#import "RTMyHistoryModel.h"
#import "RTGameModel.h"
#import "RTResultModel.h"
#import "NSDate+Extension.h"

@implementation RTMyHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setter
- (void)setMyHistoryModel:(RTMyHistoryModel *)myHistoryModel {
    _myHistoryModel = myHistoryModel;
    // 测试用
    if (!myHistoryModel) {
        return;
    }
    // 赋值
    // deadline 没有格式化
    self.dateLbl.text = myHistoryModel.result.updated_at;
    // rank
    self.rankLbl.text = myHistoryModel.result.rank;
    // distance
    self.distanceLbl.text = myHistoryModel.game.distance;
    // usedTime 结束 减去 开始
    self.timeLbl.text = [NSDate timeIntervalWithDateStr1:myHistoryModel.result.updated_at dateStr2:myHistoryModel.result.created_at];
}

@end

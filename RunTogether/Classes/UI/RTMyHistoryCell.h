//
//  RTMyHistoryCell.h
//  RunTogether
//
//  Created by yaochao on 15/11/25.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTMyHistoryModel;

@interface RTMyHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@property (weak, nonatomic) IBOutlet UILabel *distanceLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (nonatomic, strong) RTMyHistoryModel *myHistoryModel;
@end

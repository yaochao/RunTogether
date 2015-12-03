//
//  RTRunningController.m
//  RunTogether
//
//  Created by yaochao on 15/12/3.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTRunningController.h"
#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"
#import "RTGameRankChangedBodyModel.h"
#import "RTGameOverBodyRankModel.h"
#import "RTKeyChainTools.h"

#define RankMap @[@"一", @"二", @"三", @"四", @"五"]

@interface RTRunningController ()
@property (weak, nonatomic) IBOutlet UIImageView *onlineStatus;
@property (weak, nonatomic) IBOutlet UIImageView *signalImg;
@property (weak, nonatomic) IBOutlet UILabel *rankLbl;
@property (weak, nonatomic) IBOutlet UILabel *currentDistance;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *behindLbl;
@property (weak, nonatomic) IBOutlet UILabel *ahead;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animationImgView;
@property (nonatomic, strong) RTGameRankChangedBodyModel *rankChangedBodyModel;
@end

@implementation RTRunningController

#pragma mark - dismiss
- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"RTRunningController dismissed!");
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [RTNotificationCenter addObserver:self selector:@selector(receivedPushNotification:) name:RTGameRankChangedNotification object:nil];
}


#pragma mark - 收到通知
- (void)receivedPushNotification:(NSNotification *)notification {
    RTGameRankChangedBodyModel *rankChangedBodyModel = notification.userInfo[RTGameRankChangedKey];
    self.rankChangedBodyModel = rankChangedBodyModel;
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.animationImgView.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dog" ofType:@"gif"]]];
    // 圆角
    self.onlineStatus.layer.cornerRadius = self.onlineStatus.frame.size.width / 2;
    self.onlineStatus.layer.masksToBounds = YES;
    self.animationImgView.layer.cornerRadius = 10;
    self.animationImgView.layer.masksToBounds = YES;
}


#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setter 
- (void)setRankChangedBodyModel:(RTGameRankChangedBodyModel *)rankChangedBodyModel {
    _rankChangedBodyModel = rankChangedBodyModel;
    // 控件赋值
#warning TODO
    // 取出本身的model
    RTGameStartedBodyUsersModel *meModel = nil;
    RTGameOverBodyRankModel *behindOverBodyRankModel = nil;
    RTGameOverBodyRankModel *aheadOverBodyRankModel = nil;
    RTGameOverBodyRankModel *meOverBodyRankModel = nil;
    int meIndex = 0;
    NSString *meId = [RTKeyChainTools getUserId];
    for (int i = 0; i < rankChangedBodyModel.rank.count; i++) {
        RTGameOverBodyRankModel *overBodyRankModel = rankChangedBodyModel.rank[i];
        if ([overBodyRankModel.user.id isEqualToString:meId]) {
            meModel = overBodyRankModel.user;
            meIndex = i;
        }
    }
    // 已经拿到了个人model和index
    self.rankLbl.text = [NSString stringWithFormat:@"第%@名", RankMap[meIndex]];
    // 我排第一名，我前面没人
    if (meIndex != 0 && meIndex != (rankChangedBodyModel.rank.count - 1)) {
        behindOverBodyRankModel = rankChangedBodyModel.rank[meIndex + 1];
        aheadOverBodyRankModel = rankChangedBodyModel.rank[meIndex - 1];
        self.behindLbl.text = [NSString stringWithFormat:@"%i",  [meOverBodyRankModel.distance intValue] - [behindOverBodyRankModel.distance intValue]];
        self.ahead.text = [NSString stringWithFormat:@"%i",  [aheadOverBodyRankModel.distance intValue] - [meOverBodyRankModel.distance intValue]];
    }
    // 我排第一名，我前面没人
    if (meIndex == 0) {
        behindOverBodyRankModel = rankChangedBodyModel.rank[meIndex + 1];
         self.behindLbl.text = [NSString stringWithFormat:@"%i",  [meOverBodyRankModel.distance intValue] - [behindOverBodyRankModel.distance intValue]];
        self.ahead.text = @"";
    }
    // 我最后一名，我后面没人
    if (meIndex == rankChangedBodyModel.rank.count - 1) {
        aheadOverBodyRankModel = rankChangedBodyModel.rank[meIndex - 1];
        self.ahead.text = [NSString stringWithFormat:@"%i",  [aheadOverBodyRankModel.distance intValue] - [meOverBodyRankModel.distance intValue]];
        self.behindLbl.text = @"";
    }
    // 我的当前总距离
    self.currentDistance.text = [NSString stringWithFormat:@"%@M", meOverBodyRankModel.distance];
    // 我的当前的时间
#warning TODO
    // ...
}


#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
    [RTNotificationCenter removeObserver:self];
}

@end

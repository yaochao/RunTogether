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
    // ...
    
}


@end

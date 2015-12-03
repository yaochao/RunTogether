//
//  RTPrepareController.m
//  RunTogether
//
//  Created by yaochao on 15/11/30.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTPrepareController.h"
#import "RTDetectorController.h"
#import "RTMatchingController.h"
#import "RTMatchResultController.h"
#import "RTRunningController.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import "MBProgressHUD+MJ.h"


#define BottomViewHeight 200
#define DecetorViewHeight 300
#define MatchingViewHeight self.topView.frame.size.height
#define MatchResultViewHeight self.topView.frame.size.height

@interface RTPrepareController () <RTDetectorDelegate, RTMatchingDelegate, RTMatchResultDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) RTDetectorController *detectorController;
@property (nonatomic, strong) RTMatchingController *matchingController;
@property (nonatomic, strong) RTMatchResultController *matchResultController;
@property (nonatomic, weak) RTRunningController *runningController;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animatedImgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@end

@implementation RTPrepareController

- (IBAction)redetectBtnClick:(id)sender {
    [self.detectorController detectAll];
}

#pragma mark - RTDetectorDelegate
- (void)detector:(RTDetectorController *)detector didFinishedDetect:(NSMutableArray *)detectorResult {
    for (int i =0; i < 5; i++) {
        if ([detectorResult[i] isEqualToString:@"no"]) {
            // 检测不通过
            [MBProgressHUD showError:@"对不起，检测不通过"];
            break;
        }
        if (i == 4) {
            // 检测通过
            [MBProgressHUD showSuccess:@"恭喜您，检测通过"];
            // 切换到下一页
            [self.topView addSubview:self.matchingController.view];
            // 移除检测页
            [self.detectorController.view removeFromSuperview];
            self.detectorController = nil;
        }
        
    }
}


#pragma mark - RTMatchingDelegate
- (void)matching:(RTMatchingController *)matchingController totalStep:(NSInteger)totalStep {
    if (totalStep < 10) {
        // 播放语音 提示他 没有达到标准
        [MBProgressHUD showError:@"运动没有达到标准，动起来"];
        // ...
        return;
    }
    // 切换到下一页
    [MBProgressHUD showSuccess:@"恭喜您，您已加入了匹配"];
    [self.topView addSubview:self.matchResultController.view];
    [matchingController stopMonitor];
    // 移除动起来页
    [self.matchingController.view removeFromSuperview];
}

#pragma mark - RTMatchResultDelegate
- (void)matchResult:(RTMatchResultController *)matchResultController didFinishedMatch:(NSArray *)users {
    // 开始动画倒计时
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countDown" ofType:@"gif"]];
    FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:gifData];
    self.animatedImgView.animatedImage = animatedImg;
    // 隐藏菊花
    [self.indicatorView stopAnimating];
    // 等待5秒进入Running页
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:self.runningController animated:YES completion:nil];
    });
    
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // setupView
    [self setupView];
}


#pragma mark - setupView
- (void)setupView {
    CGRect topViewFrame = CGRectMake(0, 64, Screen_W, Screen_H - BottomViewHeight - 64);
    self.topView.frame = topViewFrame;
    
    // setup topView's content
    [self.topView addSubview:self.detectorController.view];
}


#pragma mark - getter
- (RTDetectorController *)detectorController {
    if (_detectorController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTDetector" bundle:nil];
        _detectorController = [sb instantiateInitialViewController];
        _detectorController.view.frame = CGRectMake(0, (self.topView.frame.size.height - DecetorViewHeight) / 2, self.topView.frame.size.width, DecetorViewHeight);
        _detectorController.delegate = self;
        
    }
    return _detectorController;
}

- (RTMatchingController *)matchingController {
    if (_matchingController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTMatching" bundle:nil];
        _matchingController = [sb instantiateInitialViewController];
        _matchingController.view.frame = CGRectMake(0, (self.topView.frame.size.height - MatchingViewHeight) / 2, self.topView.frame.size.width, MatchingViewHeight);
        _matchingController.delegate = self;
    }
    return _matchingController;
}

- (RTMatchResultController *)matchResultController {
    if (_matchResultController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTMatchResult" bundle:nil];
        _matchResultController = [sb instantiateInitialViewController];
        _matchResultController.view.frame = CGRectMake(0, (self.topView.frame.size.height - MatchResultViewHeight) / 2, self.topView.frame.size.width, MatchResultViewHeight);
        _matchResultController.delegate = self;
    }
    return _matchResultController;
}

- (RTRunningController *)runningController {
    if (_runningController ==nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTRunning" bundle:nil];
        _runningController = [sb instantiateInitialViewController];
    }
    return _runningController;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
}

@end

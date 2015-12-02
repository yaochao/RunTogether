//
//  RTMatchingController.m
//  RunTogether
//
//  Created by yaochao on 15/12/1.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTMatchingController.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>

@interface RTMatchingController (){
    NSTimer *timer;
    NSInteger totalStep;
}
@property (weak, nonatomic) IBOutlet UILabel *hiLbl;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animatedImgView;

@end

@implementation RTMatchingController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // setupView
    [self setupView];
    // 开启检测
    [self startMonitor];
}

- (void)setupView {
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dog" ofType:@"gif"]]];
    self.animatedImgView.animatedImage = animatedImage;
}

#pragma mark - startMonitor
- (void)startMonitor {
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(countStep) userInfo:nil repeats:YES];
}

- (void)countStep {
#warning TODO
    // 计步开始
    totalStep = 15;
    // 掉用代理
    [self.delegate matching:self totalStep:totalStep];
}

#pragma mark - stopMonitor
- (void)stopMonitor {
    [timer invalidate];
    timer = nil;
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
}

@end

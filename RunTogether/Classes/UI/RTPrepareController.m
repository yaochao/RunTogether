//
//  RTPrepareController.m
//  RunTogether
//
//  Created by yaochao on 15/11/30.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTPrepareController.h"
#import "RTDetectorController.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>


#define BottomViewHeight 200
#define DecetorViewHeight 300

@interface RTPrepareController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) RTDetectorController *detectorController;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animatedImgView;

@end

@implementation RTPrepareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setupView
    
    CGRect topViewFrame = CGRectMake(0, 64, Screen_W, Screen_H - BottomViewHeight - 64);
    self.topView.frame = topViewFrame;
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dog" ofType:@"gif"]];
    FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:gifData];
    self.animatedImgView.animatedImage = animatedImg;
    // setupView
    [self setupView];
}

#pragma mark - setupView
- (void)setupView {
    [self.topView addSubview:self.detectorController.view];
    self.detectorController.view.frame = CGRectMake(0, (self.topView.frame.size.height - DecetorViewHeight) / 2, self.topView.frame.size.width, DecetorViewHeight);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (RTDetectorController *)detectorController {
    if (_detectorController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTDetector" bundle:nil];
        _detectorController = [sb instantiateInitialViewController];
    }
    return _detectorController;
}

#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
}

@end

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
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>


#define BottomViewHeight 200
#define DecetorViewHeight 300
#define MatchingViewHeight self.topView.frame.size.height
#define MatchResultViewHeight self.topView.frame.size.height

@interface RTPrepareController () <RTDetectorDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) RTDetectorController *detectorController;
@property (nonatomic, strong) RTMatchingController *matchingController;
@property (nonatomic, strong) RTMatchResultController *matchResultController;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animatedImgView;

@end

@implementation RTPrepareController

- (IBAction)redetectBtnClick:(id)sender {
    [self.detectorController detectAll];
}

#pragma mark - RTDetectorDelegate
- (void)detector:(RTDetectorController *)detector didFinishedDetect:(NSMutableArray *)detectorResult {
    for (NSString *result in detectorResult) {
        NSLog(@"%@", result);
    }
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
    // gif
    NSData *gifData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dog" ofType:@"gif"]];
    FLAnimatedImage *animatedImg = [FLAnimatedImage animatedImageWithGIFData:gifData];
    self.animatedImgView.animatedImage = animatedImg;
    
    // setup topView's content
    [self.topView addSubview:self.detectorController.view];
//    [self.topView addSubview:self.matchingController.view];
//    [self.topView addSubview:self.matchResultController.view];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    }
    return _matchingController;
}

- (RTMatchResultController *)matchResultController {
    if (_matchResultController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTMatchResult" bundle:nil];
        _matchResultController = [sb instantiateInitialViewController];
        _matchResultController.view.frame = CGRectMake(0, (self.topView.frame.size.height - MatchResultViewHeight) / 2, self.topView.frame.size.width, MatchResultViewHeight);

    }
    return _matchResultController;
}


#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
}

@end

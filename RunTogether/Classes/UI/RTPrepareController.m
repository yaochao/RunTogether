//
//  RTPrepareController.m
//  RunTogether
//
//  Created by yaochao on 15/11/30.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTPrepareController.h"
#import "RTDetectorController.h"

@interface RTPrepareController ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *topCenterView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) RTDetectorController *detectorController;

@end

@implementation RTPrepareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // setupView
    [self setupView];
    
}

#pragma mark - setupView
- (void)setupView {
    self.detectorController.view.frame = CGRectMake(0, 0, self.topCenterView.frame.size.width, self.topCenterView.frame.size.height);
    [self.topCenterView addSubview:self.detectorController.view];
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

@end

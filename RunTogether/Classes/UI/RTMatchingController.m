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

@interface RTMatchingController ()
@property (weak, nonatomic) IBOutlet UILabel *hiLbl;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *animatedImgView;

@end

@implementation RTMatchingController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // setupView
    [self setupView];
}

- (void)setupView {
    FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dog" ofType:@"gif"]]];
    self.animatedImgView.animatedImage = animatedImage;
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

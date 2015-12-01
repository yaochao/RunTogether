//
//  RTDetectorController.m
//  RunTogether
//
//  Created by yaochao on 15/11/30.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTDetectorController.h"
#import <CoreLocation/CoreLocation.h>
#import <FLAnimatedImage/FLAnimatedImageView.h>
#import <FLAnimatedImage/FLAnimatedImage.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "RTKeyChainTools.h"

@interface RTDetectorController ()
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *gpsCheckbox;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *networkCheckbox;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *batteryCheckbox;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *micCheckbox;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *earCheckbox;
@property (nonatomic, strong) FLAnimatedImage *animatedImg;
@end

@implementation RTDetectorController


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.animatedImg = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detector" ofType:@"gif"]]];
    [self detectGPS];
}

- (void)detectGPS {
    self.gpsCheckbox.animatedImage = self.animatedImg;
    BOOL locationEnable = [CLLocationManager locationServicesEnabled];
    if (!locationEnable) {
        self.gpsCheckbox.animatedImage = nil;
        self.gpsCheckbox.image = [UIImage imageNamed:@"checkbox_error"];
        NSLog(@"GPS failed!");
    } else {
        self.gpsCheckbox.animatedImage = nil;
        self.gpsCheckbox.image = [UIImage imageNamed:@"checkbox_checked"];
        NSLog(@"GPS OK!");
    }
}

- (void)detectNetwork {
    // 前面已经做好，这边只需调用即可
    NSString *lastNetworkReachabilityStatus = [RTKeyChainTools getLastNetworkReachabilityStatus];
    if ([lastNetworkReachabilityStatus isEqualToString:@"unconnected"]) {
        self.gpsCheckbox.animatedImage = nil;
        self.gpsCheckbox.image = [UIImage imageNamed:@"checkbox_error"];
        NSLog(@"Network unconnected!");
    } else {
        self.gpsCheckbox.animatedImage = nil;
        self.gpsCheckbox.image = [UIImage imageNamed:@"checkbox_checked"];
        NSLog(@"Network OK!");
    }
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

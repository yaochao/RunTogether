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
#import "IOPowerSources.h"
#import "IOPSKeys.h"
#import <AVFoundation/AVFoundation.h>

#define DelayInSeconds 0.6

@interface RTDetectorController ()
{
    NSMutableArray *detectorResult;
}
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
    self.animatedImg = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"detectorLoading" ofType:@"gif"]]];
    // 开始检测GPS
    [self detectAll];
}


#pragma mark - detect
- (void)detectAll {
    [self detectGPS];
}

- (void)detectGPS {
    self.gpsCheckbox.animatedImage = self.animatedImg;
    // 初始化数组
    detectorResult = [NSMutableArray array];
    // 延时
    __block typeof(self) bself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DelayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL locationEnable = [CLLocationManager locationServicesEnabled];
        if (!locationEnable) {
            self.gpsCheckbox.animatedImage = nil;
            self.gpsCheckbox.image = [UIImage imageNamed:@"checkbox_error"];
            [detectorResult addObject:@"no"];
            NSLog(@"GPS failed!");
        } else {
            self.gpsCheckbox.animatedImage = nil;
            self.gpsCheckbox.image = [UIImage imageNamed:@"checkbox_checked"];
            [detectorResult addObject:@"yes"];
            NSLog(@"GPS OK!");
        }
        [bself detectNetwork];
    });
}

- (void)detectNetwork {
    self.networkCheckbox.animatedImage = self.animatedImg;
    //延时
    __block typeof(self) bself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DelayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *lastNetworkReachabilityStatus = [RTKeyChainTools getLastNetworkReachabilityStatus];
        if ([lastNetworkReachabilityStatus isEqualToString:@"unconnected"]) {
            self.networkCheckbox.animatedImage = nil;
            self.networkCheckbox.image = [UIImage imageNamed:@"checkbox_error"];
            [detectorResult addObject:@"no"];
            NSLog(@"Network unconnected!");
        } else {
            self.networkCheckbox.animatedImage = nil;
            self.networkCheckbox.image = [UIImage imageNamed:@"checkbox_checked"];
            [detectorResult addObject:@"yes"];
            NSLog(@"Network OK!");
        }
        [bself detectBattery];
    });
}

- (void)detectBattery {
    self.batteryCheckbox.animatedImage = self.animatedImg;
    // 延时
    __block typeof(self) bself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DelayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"当前电量%f", [self getCurrentBatteryLevel]);
        if ([self getCurrentBatteryLevel] <= 10) {
            self.batteryCheckbox.animatedImage = nil;
            self.batteryCheckbox.image = [UIImage imageNamed:@"checkbox_error"];
            [detectorResult addObject:@"no"];
            NSLog(@"电量不足，剩余%f", [self getCurrentBatteryLevel]);
        } else {
            self.batteryCheckbox.animatedImage = nil;
            self.batteryCheckbox.image = [UIImage imageNamed:@"checkbox_checked"];
            [detectorResult addObject:@"yes"];
            NSLog(@"Battery OK!");
        }
        [bself detectMic];
    });
}

- (void)detectMic {
    self.micCheckbox.animatedImage = self.animatedImg;
    // 延时
    __block typeof(self) bself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DelayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self checkMic]) {
            self.micCheckbox.animatedImage = nil;
            self.micCheckbox.image = [UIImage imageNamed:@"checkbox_error"];
            [detectorResult addObject:@"no"];
            NSLog(@"Mic failed!");
        } else {
            self.micCheckbox.animatedImage = nil;
            self.micCheckbox.image = [UIImage imageNamed:@"checkbox_checked"];
            [detectorResult addObject:@"yes"];
            NSLog(@"Mic OK!");
        }
        [bself detectEar];
    });
}

- (void)detectEar {
    self.earCheckbox.animatedImage = self.animatedImg;
    // 延时
    __block typeof(self) bself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DelayInSeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self checkEar]) {
            self.earCheckbox.animatedImage = nil;
            self.earCheckbox.image = [UIImage imageNamed:@"checkbox_error"];
            [detectorResult addObject:@"no"];
            NSLog(@"Ear failed!");
        } else {
            self.earCheckbox.animatedImage = nil;
            self.earCheckbox.image = [UIImage imageNamed:@"checkbox_checked"];
            [detectorResult addObject:@"yes"];
            NSLog(@"Ear OK!");
        }
        [bself.delegate detector:bself didFinishedDetect:detectorResult];
    });
}


#pragma mark - 获得电量
-(CGFloat)getCurrentBatteryLevel
{
    //Returns a blob of Power Source information in an opaque CFTypeRef.
    CFTypeRef blob = IOPSCopyPowerSourcesInfo();
    //Returns a CFArray of Power Source handles, each of type CFTypeRef.
    CFArrayRef sources = IOPSCopyPowerSourcesList(blob);
    CFDictionaryRef pSource = NULL;
    const void *psValue;
    //Returns the number of values currently in an array.
    long numOfSources = CFArrayGetCount(sources);
    //Error in CFArrayGetCount
    if (numOfSources == 0)
    {
        NSLog(@"Error in CFArrayGetCount");
        return -1.0f;
    }
    //Calculating the remaining energy
    for (int i = 0 ; i < numOfSources; i++)
    {
        //Returns a CFDictionary with readable information about the specific power source.
        pSource = IOPSGetPowerSourceDescription(blob, CFArrayGetValueAtIndex(sources, i));
        if (!pSource)
        {
            NSLog(@"Error in IOPSGetPowerSourceDescription");
            return -1.0f;
        }
        psValue = (CFStringRef)CFDictionaryGetValue(pSource, CFSTR(kIOPSNameKey));
        
        int curCapacity = 0;
        int maxCapacity = 0;
        double percent;
        
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSCurrentCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &curCapacity);
        psValue = CFDictionaryGetValue(pSource, CFSTR(kIOPSMaxCapacityKey));
        CFNumberGetValue((CFNumberRef)psValue, kCFNumberSInt32Type, &maxCapacity);
        percent = ((double)curCapacity/(double)maxCapacity * 100.0f);
        return percent;
    }
    return -1.0f;
}

#pragma mark - 检测麦克
- (BOOL)checkMic {
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    __block BOOL isAvailable = NO;
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [avSession requestRecordPermission:^(BOOL available) {
            isAvailable = available;
            if (available) {
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许xx访问你的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
            }
            }];
    }
    return isAvailable;
}

#pragma mark - 检测是否插入了耳机
- (BOOL)checkEar {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
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

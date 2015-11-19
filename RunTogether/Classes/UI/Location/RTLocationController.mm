//
//  RTLocationController.m
//  RunTogether
//
//  Created by yaochao on 15/11/5.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTLocationController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "RTLocationTools.h"
#import "RTLocationModel.h"
#import "RTKeyChainTools.h"
#import "MBProgressHUD+MJ.h"
#import "RTNetworkTools.h"



@interface RTLocationController () <BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLbl;
@property (nonatomic, strong) RTLocationModel *locationModel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation RTLocationController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加mapView
    [self.view addSubview:self.mapView];
    // 注册通知，接受定位的通知
    [RTNotificationCenter addObserver:self selector:@selector(receivedLocationNotification:) name:@"LocationSuccessNotification" object:nil];
}

#pragma mark - 初始化一个定时器 NSTimer
- (void)initTimer {
    // 初始化之前，先废除原来的
    [self invalidateTimer];
    // 初始化
    NSTimeInterval timeInterval = 10.0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(updateLocation) userInfo:nil repeats:YES];
}

#pragma mark - 废除定时器
- (void)invalidateTimer {
    if ([self.timer isValid]) {
        [self.timer invalidate];
    }
    self.timer = nil;
}

#pragma mark - 收到坐标变化的通知
- (void)receivedLocationNotification:(NSNotification *)notification {
    //去除HUD
//    [MBProgressHUD hideHUD];
    _locationModel = notification.userInfo[@"LocationSuccessKey"];
    // 更新地理坐标显示
    _coordinateLbl.text = [NSString stringWithFormat:@"%f - %f", _locationModel.point.latitude, _locationModel.point.longitude];
}


#pragma mark - 上传用户地理位置到服务器
- (BOOL)updateLocation {
    // 如果模型为空就不上传
    if (!self.locationModel) {
        return NO;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"latitude"] = @(self.locationModel.point.latitude);
    params[@"longitude"] = @(self.locationModel.point.longitude);
    NSString *interface = [NSString stringWithFormat:@"users/%@/locations", [RTKeyChainTools getUserId]];
    [RTNetworkTools postDataWithParams:params interfaceType:interface success:^(NSDictionary *responseObject) {
        NSLog(@"位置更新成功 - %@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"位置更新失败 - %@", error);
    }];

    return YES;
}


#pragma mark - btnClick
- (IBAction)startLocationBtnClick:(id)sender {
//    [MBProgressHUD showMessage:@"正在开启定位..."];
    [RTLocationTools startLocation];
#warning 重大BUG已修复
    [self initTimer];
}

- (IBAction)stopLocationBtnClick:(id)sender {
//    [MBProgressHUD showMessage:@"正在关闭定位..."];
    [RTLocationTools stopLocation];
//    _coordinateLbl.text = @"请开启定位";
//    [MBProgressHUD hideHUD];
    [self invalidateTimer];
}


#pragma mark - 懒加载
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        CGRect mapViewFrame = CGRectMake(0, 64, Screen_W, (Screen_H - 64) / 2);
        _mapView = [[BMKMapView alloc] initWithFrame:mapViewFrame];
        _mapView.delegate = self; // 设置代理
        _mapView.showsUserLocation = YES; // 设置为可以显示用户位置
        _mapView.zoomLevel = 16; // 地图的缩放比例
    }
    return _mapView;
}

#pragma mark - dealloc
- (void)dealloc {
    [RTNotificationCenter removeObserver:self];
}


@end

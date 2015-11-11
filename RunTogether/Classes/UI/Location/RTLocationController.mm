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
#import "MaxwellClient.h"
#import "RTMaxwellListener.h"


@interface RTLocationController () <BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLbl;
@property (nonatomic, strong) RTLocationModel *locationModel;
@property (nonatomic, strong) MaxwellClient *maxwellClient;
@end

@implementation RTLocationController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加mapView
    [self.view addSubview:self.mapView];
    // 注册通知，接受定位的通知
    [RTNotificationCenter addObserver:self selector:@selector(receivedLocationNotification:) name:@"LocationSuccessNotification" object:nil];
    [self startMaxwellClient];
}

#pragma mark - 启动Maxwell
- (void)startMaxwellClient {
    // 加载Maxwell
    RTMaxwellListener *listener = [[RTMaxwellListener alloc] init];
    _maxwellClient = [[MaxwellClient alloc] initWithEndpoint:[RTKeyChainTools getEndpoint] withUserId:[NSNumber numberWithInt:[[RTKeyChainTools getUserId] intValue]] withSessionKey:[RTKeyChainTools getSessionKey] withListener:listener];
    // 启动Maxwell
    [_maxwellClient start];
}


#pragma mark - ----
- (void)receivedLocationNotification:(NSNotification *)notification {
    //去除HUD
    [MBProgressHUD hideHUD];
    _locationModel = notification.userInfo[@"LocationSuccessKey"];
    // 更新地理坐标显示
    _coordinateLbl.text = [NSString stringWithFormat:@"%f - %f", _locationModel.point.latitude, _locationModel.point.longitude];
    // 上传到服务器，每次收到都上传
    [self updateLocation:_locationModel];
}


#pragma mark - 上传用户地理位置到服务器
- (BOOL)updateLocation:(RTLocationModel *)locationModel {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"latitude"] = @(locationModel.point.latitude);
    params[@"longitude"] = @(locationModel.point.longitude);
    NSString *interface = [NSString stringWithFormat:@"users/%@/locations", [RTKeyChainTools getUserId]];
    [RTNetworkTools postDataWithParams:params interfaceType:interface success:^(NSDictionary *responseObject) {
        NSLog(@"更新用户位置 - %@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"位置更新失败 - %@", error);
    }];

    return YES;
}


#pragma mark - btnClick
- (IBAction)startLocationBtnClick:(id)sender {
    [MBProgressHUD showMessage:@"正在开启定位..."];
    [RTLocationTools startLocation];
}

- (IBAction)stopLocationBtnClick:(id)sender {
    [MBProgressHUD showMessage:@"正在关闭定位..."];
    [RTLocationTools stopLocation];
    _coordinateLbl.text = @"请开启定位";
    [MBProgressHUD hideHUD];
    // 关闭Maxwell
    [_maxwellClient stop];
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

@end

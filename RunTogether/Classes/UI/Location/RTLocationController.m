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
//#import "RTMaxwellListener.h"


@interface RTLocationController () <BMKMapViewDelegate>
@property (nonatomic, strong) BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *coordinateLbl;
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

- (void)receivedLocationNotification:(NSNotification *)notification {
    //去除HUD
    [MBProgressHUD hideHUD];
    RTLocationModel *locationModel = notification.userInfo[@"LocationSuccessKey"];
    // 更新地理坐标显示
    _coordinateLbl.text = [NSString stringWithFormat:@"%f - %f", locationModel.point.latitude, locationModel.point.longitude];
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

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

@interface RTLocationController () <BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) UILabel *coordinateLbl;

@end

@implementation RTLocationController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加mapView
    [self.view addSubview:self.mapView];
    
}

#pragma mark - 懒加载
- (BMKMapView *)mapView {
    if (_mapView == nil) {
        CGRect mapViewFrame = CGRectMake(0, 64, Screen_W, (Screen_H - 64) / 2);
        _mapView = [[BMKMapView alloc] initWithFrame:mapViewFrame];
        _mapView.delegate = self; // 设置代理
        _mapView.showsUserLocation = YES; //设置为可以显示用户位置
        _mapView.zoomLevel = 16; // 地图的缩放比例
    }
    return _mapView;
}

@end

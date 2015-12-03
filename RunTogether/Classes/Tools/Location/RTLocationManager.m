//
//  RTLocationManager.m
//  GaodeMap
//
//  Created by 赵欢 on 15/12/2.
//  Copyright © 2015年 赵欢. All rights reserved.
//

#import "RTLocationManager.h"
#import "RTLocationModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface RTLocationManager ()<AMapLocationManagerDelegate,AMapSearchDelegate>

@property (nonatomic, strong) RTLocationModel *locationInfo;
@property (nonatomic, assign) CLLocationCoordinate2D point;
//@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapLocationManager* locationManager;

@end

@implementation RTLocationManager

#pragma mark - 懒加载
- (RTLocationModel *)locationInfo {
    if (_locationInfo == nil) {
        _locationInfo = [[RTLocationModel alloc] init];
    }
    return _locationInfo;
}

- (void)startLocation{
    
    [AMapLocationServices sharedServices].apiKey = GaodeKey;
    
    self.locationManager = [[AMapLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    //    self.mapView.showsUserLocation = YES;
    NSLog(@"高德地图启动成功！");
    
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    [self reverseGeocodeWith:CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)];
}

- (void)stopLocation{
    
    [self.locationManager stopUpdatingLocation];
    
}
- (void)reverseGeocodeWith:(CLLocationCoordinate2D)point{
    [AMapSearchServices sharedServices].apiKey = GaodeKey;
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc]init];
    regeo.location = [AMapGeoPoint locationWithLatitude:point.latitude longitude:point.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}
#pragma mark - 实现逆地址编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    self.locationInfo.city = response.regeocode.addressComponent.city;
    self.locationInfo.addrName = response.regeocode.formattedAddress;
    self.locationInfo.point = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
    NSLog(@"%@",self.locationInfo.addrName);
    
    // 2. 发通知
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.locationInfo forKey:@"LocationSuccessKey"];
    [RTNotificationCenter postNotificationName:@"LocationSuccessNotification" object:nil userInfo:userInfo];
    
}

@end

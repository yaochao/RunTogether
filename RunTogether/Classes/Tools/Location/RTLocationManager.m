//
//  RTLocationManager.m
//  RunTogether
//
//  Created by yaochao on 15/11/5.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTLocationManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import "RTLocationModel.h"

@interface RTLocationManager ()  <BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate, BMKPoiSearchDelegate>

@property (nonatomic, strong) BMKLocationService *locationService;
@property (nonatomic, strong) BMKGeoCodeSearch *geoSearch;
@property (nonatomic, strong) RTLocationModel *locationInfo;
@property (nonatomic, assign) CLLocationCoordinate2D point;
@end

@implementation RTLocationManager


#pragma mark - 懒加载
- (RTLocationModel *)locationInfo {
    if (_locationInfo == nil) {
        _locationInfo = [[RTLocationModel alloc] init];
    }
    return _locationInfo;
}

- (BMKGeoCodeSearch *)geoSearch {
    if (_geoSearch == nil) {
        _geoSearch = [[BMKGeoCodeSearch alloc] init];
    }
    return _geoSearch;
}

#pragma mark - setter方法


#pragma mark - 开启定位
- (void)startLocation {
    BMKLocationService *locationService = [[BMKLocationService alloc] init];
    locationService.delegate = self;
    [locationService startUserLocationService];
    self.locationService = locationService;
    
}


#pragma mark - 结束定位
- (void)stopLocation {
    [self.locationService stopUserLocationService];
    self.locationService.delegate = nil;
//    self.geoSearch.delegate = nil;
}



#pragma mark - 定位服务的代理方法
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser {
    NSLog(@"定位服务开启...");
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser {
    NSLog(@"定位服务关闭...");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
//    NSLog(@"用户方向更新...");
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    NSLog(@"用户位置更新...");
    self.locationInfo.point = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    NSLog(@"%f, %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    
    // 给 locationInfo 的 point 属性赋值
    self.locationInfo.point = userLocation.location.coordinate;
    self.point = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    // 地理编码, 把位置发出去
    [self reverseGeocodeWith:self.point];
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"定位失败，错误 - %@", error);
}

#pragma mark - 反地理编码
- (void)reverseGeocodeWith:(CLLocationCoordinate2D)point {
    
    
    NSLog(@"要反编码的坐标 - %f - %f", point.latitude, point.longitude);
    self.geoSearch.delegate = self;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = point;
    [self.geoSearch reverseGeoCode:option];
}

#pragma mark - 反地理编码代理
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    // 如果出错就返回
    if (error) {
        NSLog(@"反地理编码错误 - %u", error);
        return;
    }
    
    // 没有错误就发送通知，把地名和坐标发出。
    // 1. 给 userInfo 的 addrName 属性赋值
    self.locationInfo = [[RTLocationModel alloc] init];
    self.locationInfo.addrName = result.address;
    self.locationInfo.city = result.addressDetail.city;
    self.locationInfo.point = result.location;
    // 2. 发通知
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.locationInfo forKey:@"LocationSuccessKey"];
    [RTNotificationCenter postNotificationName:@"LocationSuccessNotification" object:nil userInfo:userInfo];
}


#pragma mark - poi搜索
- (BOOL)poiSearchInCity:(NSString *)city keyword:(NSString *)keyword {
    BMKCitySearchOption *citySearchOption = [[BMKCitySearchOption alloc] init];
    citySearchOption.pageIndex = 0; // 第几页
    citySearchOption.pageCapacity = 30; // 每页有多少条数据
    citySearchOption.city = city; // 要再哪个城市进行搜索
    citySearchOption.keyword = keyword;
    BMKPoiSearch *poiSearch = [[BMKPoiSearch alloc] init];
    poiSearch.delegate = self;
    return [poiSearch poiSearchInCity:citySearchOption]; // 检索成功返回yes
}

#pragma mark - poi搜索的代理方法
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode {
    
    if (errorCode == BMK_SEARCH_NO_ERROR) {
        if (poiResult.poiInfoList == nil) {
            return;
        }
        // 发送通知，BMKPoiResult发出去
        [RTNotificationCenter postNotificationName:@"PoiResultNotification" object:nil userInfo:@{@"PoiResultKey" : poiResult.poiInfoList}];
    }
}


@end

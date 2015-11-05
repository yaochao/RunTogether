//
//  RTLocationManager.h
//  RunTogether
//
//  Created by yaochao on 15/11/5.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RTLocationManager : NSObject

// 开始定位, 定位的结果以通知的形式发出
- (void)startLocation;

// 结束定位, 节省耗电
- (void)stopLocation;

// 根据城市名称，进行poi搜索
- (BOOL)poiSearchInCity:(NSString *)city keyword:(NSString *)keyword;

// 根据坐标反地理编码
- (void)reverseGeocodeWith:(CLLocationCoordinate2D)point;


@end

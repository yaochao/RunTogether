//
//  RTLocationModel.h
//  RunTogether
//
//  Created by yaochao on 15/11/5.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RTLocationModel : NSObject

/**
 *  坐标
 */
@property (nonatomic, assign) CLLocationCoordinate2D point;
/**
 *  地址
 */
@property (nonatomic, strong) NSString *addrName;
/**
 *  城市名
 */
@property (nonatomic, copy) NSString *city;

@end

//
//  NSString+BBExtension.h
//  bobo
//
//  Created by pp on 15/6/21.
//  Copyright (c) 2015年 bobo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BBExtension)

/**
 *  根据十六进制字符串颜色值，返回 UIColor 类型的颜色
 *
 *  @return UIColor颜色
 */
- (UIColor *)hexColor;

@end

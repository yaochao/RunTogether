//
//  UIImage+BBExtension.m
//  bobo
//
//  Created by 黄鹏飞 on 15/7/9.
//  Copyright (c) 2015年 bobo. All rights reserved.
//

#import "UIImage+BBExtension.h"

@implementation UIImage (BBExtension)

- (UIImage *)scaleImage:(CGFloat)width{
    
    
    CGSize s = [self scaleImageSize:width];
    
    UIGraphicsBeginImageContext(s);
    
    [self drawInRect:CGRectMake(0, 0, s.width,s.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return  image;
}

- (CGSize)scaleImageSize:(CGFloat)width{
    
    CGFloat scale = self.size.width / width;
    CGFloat h = self.size.height / scale;
    return CGSizeMake(width, h);
}

@end

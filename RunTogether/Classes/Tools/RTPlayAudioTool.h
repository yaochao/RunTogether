//
//  RTPlayAudioTool.h
//  RunTogether
//
//  Created by 赵欢 on 15/12/3.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RTPlayAudioTool : NSObject
/**
 *  播放音效文件
 *
 *  @param name 音频文件名称（文件名称要带后缀）
 */
+ (void)playSoundEffect:(NSString *)name;

@end

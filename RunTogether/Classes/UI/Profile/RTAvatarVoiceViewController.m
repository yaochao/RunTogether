//
//  RTAvatarVoiceViewController.m
//  RunTogether
//
//  Created by 赵欢 on 15/11/27.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTAvatarVoiceViewController.h"
#import "LVRecordTool.h"
#import "RunTogether-Bridging-Header.h"
#import "Runtogether-Swift.h"
@interface RTAvatarVoiceViewController ()<LVRecordToolDelegate>
- (IBAction)longTap:(ANLongTapButton *)sender;
- (IBAction)longTapOut:(ANLongTapButton *)sender;
- (IBAction)LongTapTouchUpInside:(ANLongTapButton *)sender;
- (IBAction)longTapTouchDragExit:(ANLongTapButton *)sender;
- (IBAction)playButtonAction:(UIButton *)sender;

/** 录音工具 */
@property (nonatomic, strong) LVRecordTool *recordTool;

/** 录音时的图片 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end

@implementation RTAvatarVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recordTool = [LVRecordTool sharedRecordTool];
    self.recordTool.delegate = self;
}
#pragma mark - 播放录音
- (void)play {
    [self.recordTool playRecordingFile];
}
- (void)dealloc {
    if ([self.recordTool.recorder isRecording]) [self.recordTool stopPlaying];
    if ([self.recordTool.player isPlaying]) [self.recordTool stopRecording];
}
#pragma mark - LVRecordToolDelegate
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(int)no {
    
    NSString *imageName = [NSString stringWithFormat:@"mic_%d", no];
    self.imageView.image = [UIImage imageNamed:imageName];
}
- (IBAction)longTap:(ANLongTapButton *)sender {
    [self.recordTool startRecording];
}
- (IBAction)longTapOut:(ANLongTapButton *)sender {
    [self.recordTool playRecordingFile];
}
- (IBAction)LongTapTouchUpInside:(ANLongTapButton *)sender {
    double currentTime = self.recordTool.recorder.currentTime;
    NSLog(@"%lf", currentTime);
    if (currentTime < 2) {
        self.imageView.image = [UIImage imageNamed:@"mic_0"];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordTool stopRecording];
            [self.recordTool destructionRecordingFile];
        });
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            [self.recordTool stopRecording];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = [UIImage imageNamed:@"mic_0"];
            });
        });
        // 已成功录音
        NSLog(@"已成功录音");
    }
    // I/O不能同时
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self play];
    });
}

- (IBAction)longTapTouchDragExit:(ANLongTapButton *)sender {
    self.imageView.image = [UIImage imageNamed:@"mic_0"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
    });
}
@end

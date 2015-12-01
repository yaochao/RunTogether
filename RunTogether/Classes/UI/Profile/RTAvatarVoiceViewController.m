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
#define RecordTime 3
@interface RTAvatarVoiceViewController ()<LVRecordToolDelegate>
- (IBAction)longTap:(ANLongTapButton *)sender;
- (IBAction)longTapOut:(ANLongTapButton *)sender;
- (IBAction)LongTapTouchUpInside:(ANLongTapButton *)sender;
- (IBAction)longTapTouchDragExit:(ANLongTapButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *recordLable;
- (IBAction)nextPage:(UIButton *)sender;


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
    self.nextButton.enabled = NO;
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
    // 限制录音时间
    [self performSelector:@selector(stopRecord) withObject:self afterDelay:RecordTime];
}
- (void)stopRecord{
    [self.recordTool stopRecording];
    NSLog(@"停");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
#warning Todo 超时声音提示
//        [self play];
//    });
}
- (IBAction)longTapOut:(ANLongTapButton *)sender {
    [self.recordTool playRecordingFile];
}
- (IBAction)LongTapTouchUpInside:(ANLongTapButton *)sender {
    self.recordLable.text = @"重录";
    // I/O不能同时
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self play];
    });
    self.nextButton.enabled = YES;
}

- (IBAction)longTapTouchDragExit:(ANLongTapButton *)sender {
    self.imageView.image = [UIImage imageNamed:@"mic_0"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self.recordTool stopRecording];
        [self.recordTool destructionRecordingFile];
    });
}
- (IBAction)nextPage:(UIButton *)sender {
}
- (void)viewWillDisappear:(BOOL)animated{
    [self.recordTool stopRecording];
    [self.recordTool destructionRecordingFile];
}
@end

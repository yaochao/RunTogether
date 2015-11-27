//
//  RTAvatarViewController.m
//  RunTogether
//
//  Created by 赵欢 on 15/11/26.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <UIButton+WebCache.h>
#import "RTAvatarViewController.h"
#import "RTNetworkTools.h"
#import "RTAvatarModel.h"
#import "RTAvatarVoiceViewController.h"

@interface RTAvatarViewController ()

@property (nonatomic, strong) NSArray *avatarModelArr;
@property (nonatomic, strong) UIView *checkView;
@property (nonatomic, strong) UIImageView *imageView;
- (IBAction)pressButton:(UIButton *)sender;

@end

@implementation RTAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self putAvatarsOnButton];
    [self createCheckView];
}
- (void)createCheckView{
    self.checkView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.checkView setBackgroundColor:[UIColor colorWithRed:1/255 green:1/255 blue:1/255 alpha:0.4]];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    [self.checkView addGestureRecognizer:tap];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width/4, height/4, width/2, height/3)];
    [self.checkView addSubview:self.imageView];
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [checkButton setFrame:CGRectMake(width/4, height/4*3, width/2, 40)];
    [checkButton setTitle:@"确认" forState:UIControlStateNormal];
    [checkButton setBackgroundColor:[UIColor redColor]];
    [checkButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [checkButton addTarget:self action:@selector(pressCheckButton) forControlEvents:UIControlEventTouchUpInside];
    [self.checkView addSubview:checkButton];
    [self.view addSubview:self.checkView];
    self.checkView.hidden = YES;

}
- (void)pressCheckButton{
    RTAvatarVoiceViewController *avatarVoiceVC = [[RTAvatarVoiceViewController alloc]init];
    [self.navigationController pushViewController:avatarVoiceVC animated:YES];
}
- (void)tapAction{
    self.checkView.hidden = YES;
}
- (void)putAvatarsOnButton{
    NSString *interface = @"sys_avatars";
    [RTNetworkTools getDataWithParams:nil interfaceType:interface success:^(id responseObject) {
        NSLogSuccessResponse;
        self.avatarModelArr = [RTAvatarModel objectArrayWithKeyValuesArray:responseObject];
        for (int i = 0; i < self.avatarModelArr.count; i++) {
            RTAvatarModel* avatarModel = self.avatarModelArr[i];
            UIButton *button = (UIButton*)[self.view viewWithTag:i+1];
            
//            [button sd_setImageWithURL:[NSURL URLWithString:avatarModel.url] forState:UIControlStateNormal];
            [button sd_setImageWithURL:[NSURL URLWithString:avatarModel.url] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        }
    } failure:^(NSError *error) {
        NSLogErrorResponse;
    }];
}
- (IBAction)pressButton:(UIButton *)sender {
    self.imageView.image = [sender imageForState:UIControlStateNormal];
    self.checkView.hidden = NO;
}
@end

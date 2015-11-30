//
//  CaptcheViewController.m
//  loading
//
//  Created by 赵欢 on 15/11/25.
//  Copyright © 2015年 赵欢. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import "CaptcheViewController.h"
#import "QueuingViewController.h"
#import "RTNetworkTools.h"
#import "RTKeyChainSingleton.h"
#import "RTLoginModel.h"
#import "RTKeyChainTools.h"
#import "RTHomeController.h"
@interface CaptcheViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captcheTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonAction:(UIButton *)sender;
- (IBAction)captcheTextAction:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UILabel *nextLable;
@property (strong, nonatomic) NSMutableDictionary *captcheDic;
@property (weak, nonatomic) IBOutlet UIButton *enterHomeBtn;

@end

@implementation CaptcheViewController

// 登录成功进入Home页
- (IBAction)enterHomeClick:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTHome" bundle:nil];
    RTHomeController *homeController = [sb instantiateInitialViewController];
    [self.navigationController pushViewController:homeController animated:YES];
    
    [self nextLableAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"country_calling_code"] = @"+86";
    params[@"phone"] = self.phone;
    params[@"security_code"] = self.captcheTextField.text;
    NSString *interface = @"sessions";
    [RTNetworkTools postDataWithParams:params interfaceType:interface success:^(id responseObject) {
        NSLogSuccessResponse;
        self.captcheDic = [[NSMutableDictionary alloc]initWithDictionary:responseObject];
        RTLoginModel *loginModel = [RTLoginModel objectWithKeyValues:responseObject];
        [RTKeyChainTools saveRememberToken:loginModel.remember_token];
        [RTKeyChainTools saveUserId:loginModel.user_id];
        [RTKeyChainTools saveSessionKey:loginModel.session_key];
        
    } failure:^(NSError *error) {
        NSLogErrorResponse;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"登陆失败" message:@"登陆失败，请检查网络和您输入的验证码是否正确" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.userInteractionEnabled = NO;
    self.nextLable.alpha = 0.4;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)nextLableAnimation{
    CGFloat width = self.nextLable.frame.size.width;
    CGFloat x = self.nextLable.frame.origin.x;
    CGFloat y = self.nextLable.frame.origin.y;
    CGFloat height = self.nextLable.frame.size.height;
    self.nextLable.alpha = 0.4;
    [self.nextLable setFrame:CGRectMake(x, y, 0, height)];
    [UIView animateWithDuration:3 animations:^{
        [self.nextLable setFrame:CGRectMake(x, y, width, height)];
    }];
}
- (IBAction)nextButtonAction:(UIButton *)sender {
    [self nextLableAnimation];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"country_calling_code"] = @"+86";
//    params[@"phone"] = self.phone;
    params[@"phone"] = @"10000";
    params[@"security_code"] = self.captcheTextField.text;
    NSString *interface = @"sessions";
    [RTNetworkTools postDataWithParams:params interfaceType:interface success:^(id responseObject) {
        NSLogSuccessResponse;
        self.captcheDic = [[NSMutableDictionary alloc]initWithDictionary:responseObject];
        RTLoginModel *loginModel = [RTLoginModel objectWithKeyValues:responseObject];
        [RTKeyChainTools saveRememberToken:loginModel.remember_token];
        [RTKeyChainTools saveUserId:loginModel.user_id];
        [RTKeyChainTools saveSessionKey:loginModel.session_key];
            
        QueuingViewController* queuingVC = [[QueuingViewController alloc]init];
        queuingVC.user_id = self.captcheDic[@"user_id"];
        [self.navigationController pushViewController:queuingVC animated:YES];
            
    } failure:^(NSError *error) {
        NSLogErrorResponse;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"登陆失败" message:@"登陆失败，请检查网络和您输入的验证码是否正确" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
        
    }];
}
- (void)viewWillAppear:(BOOL)animated{
    // 让enterHomeBtn不可点击
    self.enterHomeBtn.enabled = NO;
}
- (IBAction)captcheTextAction:(UITextField *)sender {
    if (sender.text.length == RTSecurityCodeLength) {
        self.nextButton.userInteractionEnabled = YES;
        self.enterHomeBtn.enabled = YES;
        self.nextLable.alpha = 1;
    }else{
        self.nextButton.userInteractionEnabled = NO;
        self.enterHomeBtn.enabled = NO;
        self.nextLable.alpha = 0.4;
    }
}
@end

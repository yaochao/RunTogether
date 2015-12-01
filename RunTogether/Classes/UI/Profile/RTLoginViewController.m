//
//  RTLoginViewController.m
//  loading
//
//  Created by 赵欢 on 15/11/25.
//  Copyright © 2015年 赵欢. All rights reserved.
//

#import "RTLoginViewController.h"
#import "CaptcheViewController.h"
#import "RTNetworkTools.h"
#import "RTKeyChainTools.h"

#import "MBProgressHUD+MJ.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
@interface RTLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UILabel *checkoutLable;
- (IBAction)phoneNumerAction:(UITextField *)sender;
- (IBAction)checkoutButtonAction:(UIButton *)sender;

@property (strong, nonatomic) NSDictionary *responseObject;

@end

@implementation RTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.checkoutButton.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor blackColor])];
    self.checkoutButton.userInteractionEnabled = NO;
    self.checkoutLable.alpha = 0.4;
    
    // 注册通知
    [RTNotificationCenter addObserver:self selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}


#pragma mark - 监听网络状态调用函数
- (void)reachabilityDidChange:(NSNotification *)notification {
    NSInteger status = [notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue];
    NSString *lastNetworkReachabilityStatus = [RTKeyChainTools getLastNetworkReachabilityStatus];
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
            NSLog(@" - 未知网络类型");
            break;
        case AFNetworkReachabilityStatusNotReachable:
            NSLog(@" - 网络连接已断开，请检查网络配置");
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"网络错误", nil) message:NSLocalizedString(@"网络连接已断开，请检查网络配置", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil] show];
            [RTKeyChainTools saveLastNetworkReachabilityStatus:@"unconnected"];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            NSLog(@" - 2/3/4G网络");
            if ([lastNetworkReachabilityStatus isEqualToString:@"unconnected"]) {
                [self tokenLogin];
            }
            [RTKeyChainTools saveLastNetworkReachabilityStatus:@"2/3/4G"];
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            NSLog(@" - wifi网络");
            if ([lastNetworkReachabilityStatus isEqualToString:@"unconnected"]) {
                [self tokenLogin];
            }
            [RTKeyChainTools saveLastNetworkReachabilityStatus:@"wifi"];
            break;
        default:
            break;
    }
}
// token 登录
- (void)tokenLogin {
    [self loginWithPhone:[RTKeyChainTools getPhone] proof:[RTKeyChainTools getRememberToken] type:RTLoginTokenType];
}


// 登录的封装
- (void)loginWithPhone:(NSString *)phone proof:(NSString *)proof type:(RTLoginType)type {
    // 请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = phone;
    if (type == RTLoginPasswordType) {
        params[@"password"] = proof;
    } else {
        params[@"remember_token"] = [RTKeyChainTools getRememberToken];
    }
    [RTNetworkTools postDataWithParams:params interfaceType:RTSessionsType success:^(NSDictionary *responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@", responseObject);
        _responseObject = responseObject;
        
        // 如果登录出错
        if ([responseObject objectForKey:@"errcode"] != nil) {
            [MBProgressHUD showError:[NSString stringWithFormat:NSLocalizedString(@"错误代码:%@", nil), [responseObject objectForKey:@"errcode"]]];
            return ;
        }
        
        // 如果登录成功
        [RTKeyChainTools savePhone:phone];
        [RTKeyChainTools saveRememberToken:responseObject[@"remember_token"]];
        [RTKeyChainTools saveUserId:[NSString stringWithFormat:@"%@", responseObject[@"user_id"]]];
        [RTKeyChainTools saveSessionKey:responseObject[@"session_key"]];
        [RTKeyChainTools saveEndpoint:responseObject[@"maxwell_endpoint"]];
        
        // 判断是否需要跳转页面
        if (type == RTLoginPasswordType) {
            [MBProgressHUD showSuccess:NSLocalizedString(@"登录成功", nil)];
            NSLog(@"登录成功");
            [self dismissViewControllerAnimated:YES completion:nil];
            //            self.locationVC = [[UIStoryboard storyboardWithName:@"RTLocation" bundle:nil] instantiateInitialViewController];
            //            [self.navigationController pushViewController:self.locationVC animated:YES];
        } else {
            [MBProgressHUD showSuccess:NSLocalizedString(@"后台自动登录成功", nil)];
            NSLog(@"后台自动登录成功");
        }
//        // 打开Maxwell
//        [self startMaxwellClient];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"网络错误 - %@", error);
        // 提示网络有问题
        NSString *errorMsg = [NSString stringWithFormat:NSLocalizedString(@"请检查您的网络连接\n错误代码 %li", nil), error.code];
        // 判断是否需要提示用户，隐式登录不需要
        if (type == RTLoginPasswordType) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"网络错误", nil) message:errorMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil] show];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)phoneNumerAction:(UITextField *)sender {
    if (sender.text.length >= RTPhoneNumberLength) {
        sender.text = [sender.text substringToIndex:RTPhoneNumberLength];
        self.checkoutButton.userInteractionEnabled = YES;
        self.checkoutLable.alpha = 1;
    }else{
        self.checkoutButton.userInteractionEnabled = NO;
        self.checkoutLable.alpha = 0.4;
    }
}
- (IBAction)checkoutButtonAction:(UIButton *)sender {
    CGFloat width = self.checkoutLable.frame.size.width;
    CGFloat x = self.checkoutLable.frame.origin.x;
    CGFloat y = self.checkoutLable.frame.origin.y;
    CGFloat height = self.checkoutLable.frame.size.height;
    self.checkoutLable.alpha = 0.4;
    [self.checkoutLable setFrame:CGRectMake(x, y, 0, height)];
    [UIView animateWithDuration:3 animations:^{
        [self.checkoutLable setFrame:CGRectMake(x, y, width, height)];
    }];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"country_calling_code"] = @"+86";
    params[@"phone"] = self.phoneNumberTextField.text;
    [RTKeyChainTools savePhone:self.phoneNumberTextField.text];
    NSString *interface = @"security_codes";
    [RTNetworkTools postDataWithParams:params interfaceType:interface success:^(id responseObject) {
        NSLogSuccessResponse;
            
        CaptcheViewController* captcheVC = [[CaptcheViewController alloc]init];
        [self.navigationController pushViewController:captcheVC animated:YES];
        captcheVC.phone = self.phoneNumberTextField.text;
            
    } failure:^(NSError *error) {
        NSLogErrorResponse;
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"获取验证码失败" message:@"获取验证码失败，请检查网络和您输入的手机号是否正确" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

@end


//
//  RTLoadingViewController.m
//  loading
//
//  Created by 赵欢 on 15/11/25.
//  Copyright © 2015年 赵欢. All rights reserved.
//

#import "RTLoadingViewController.h"
#import "RTLoginViewController.h"
#import "RTKeyChainTools.h"
#import "RTNetworkTools.h"
#import "MBProgressHUD+MJ.h"
#import "RTHomeController.h"

@interface RTLoadingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *beginButton;
- (IBAction)beginButtonAction:(id)sender;
@property (strong, nonatomic) NSDictionary *responseObject;



@end

@implementation RTLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.beginButton.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor blackColor])];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// token 登录
- (void)tokenLogin {
    [self loginWithPhone:[RTKeyChainTools getPhone] proof:[RTKeyChainTools getRememberToken] type:RTLoginTokenType];
}


// 登录的封装
- (void)loginWithPhone:(NSString *)phone proof:(NSString *)proof type:(RTLoginType)type {
    // 请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"country_calling_code"] = @"+86";
    params[@"phone"] = phone;
    if (type == RTLoginPasswordType) {
        params[@"security_code"] = proof;
    } else {
        params[@"remember_token"] = [RTKeyChainTools getRememberToken];
    }
    [RTNetworkTools postDataWithParams:params interfaceType:RTSessionsType success:^(NSDictionary *responseObject) {
        NSLogSuccessResponse;
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
        
        [MBProgressHUD showSuccess:NSLocalizedString(@"后台自动登录成功", nil)];
        NSLog(@"后台自动登录成功");
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLogErrorResponse;
        // 提示网络有问题
        NSString *errorMsg = [NSString stringWithFormat:NSLocalizedString(@"请检查您的网络连接\n错误代码 %li", nil), error.code];
        // 判断是否需要提示用户，隐式登录不需要
        if (type == RTLoginPasswordType) {
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"网络错误", nil) message:errorMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil] show];
        }
    }];
}


- (IBAction)beginButtonAction:(id)sender {
    if ([RTKeyChainTools getRememberToken] == nil) {
        RTLoginViewController *loginVC = [[RTLoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }else {
        [self tokenLogin];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTHome" bundle:nil];
        RTHomeController *homtController = [sb instantiateInitialViewController];
        [self.navigationController pushViewController:homtController animated:YES];
    }
}
@end

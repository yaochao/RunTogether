//
//  RTLoginController.m
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import "RTLoginController.h"
#import "RTKeyChainTools.h"
#import "RTLocationController.h"
#import "MBProgressHUD+MJ.h"
#import "RTNetworkTools.h"

typedef enum {
    RTLoginPasswordType,
    RTLoginTokenType
}RTLoginType;

@interface RTLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSDictionary *responseObject;
@property (nonatomic, strong) RTLocationController *locationVC;
@end

@implementation RTLoginController

#pragma mark - btnClick
// 密码登录
- (IBAction)loginBtnClick:(id)sender {
    // 判空
    if ([_phone.text isEqual:@""]) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }
    if ([_password.text isEqual:@""]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    [MBProgressHUD showMessage:@"正在登录..."];
    // 密码登录
    [self loginWithPhone:_phone.text proof:_password.text type:RTLoginPasswordType];
    
}


// token 登录
- (IBAction)tokenLoginBtnClick:(id)sender {
    [self loginWithPhone:[RTKeyChainTools getPhone] proof:[RTKeyChainTools getRememberToken] type:RTLoginTokenType];
}


// 登陆的封装
- (void)loginWithPhone:(NSString *)phone proof:(NSString *)proof type:(RTLoginType)type {
    // 请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = phone;
    if (type == RTLoginPasswordType) {
        params[@"password"] = proof;
    } else {
        params[@"remember_token"] = [RTKeyChainTools getRememberToken];
    }
    [RTNetworkTools postDataWithParams:params interfaceType:@"sessions" success:^(NSDictionary *responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@", responseObject);
        _responseObject = responseObject;
        // 对返回信息的处理
        if ([responseObject objectForKey:@"errcode"] == nil) {
            [MBProgressHUD showSuccess:@"登录成功"];
            // 存储信息到钥匙串
            if ([RTKeyChainTools savePhone:phone]) {
                NSLog(@"phone存储成功");
            }
            if ([RTKeyChainTools saveRememberToken:responseObject[@"remember_token"]]) {
                NSLog(@"remember_token存储成功");
            }
            if ([RTKeyChainTools saveUserId:[NSString stringWithFormat:@"%@", responseObject[@"user_id"]]]) {
                NSLog(@"user_id存储成功");
            }
            if ([RTKeyChainTools saveSessionKey:responseObject[@"session_key"]]) {
                NSLog(@"session_key存储成功");
            }
            if ([RTKeyChainTools saveEndpoint:responseObject[@"maxwell_endpoint"]]) {
                NSLog(@"endpoint存储成功");
            }
            
            
            // 判断是否需要跳转页面
            if (type == RTLoginPasswordType) {
                self.locationVC = [[UIStoryboard storyboardWithName:@"RTLocation" bundle:nil] instantiateInitialViewController];
                [self.navigationController pushViewController:self.locationVC animated:YES];
            }
            
        } else {
            [MBProgressHUD showError:[NSString stringWithFormat:@"错误代码:%@", [responseObject objectForKey:@"errcode"]]];
        }
        
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"网络错误 - %@", error);
        // 提示网络有问题
        NSString *errorMsg = [NSString stringWithFormat:@"请检查您的网络连接\n错误代码 %li", error.code];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

    }];
}


#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark 触摸空白结束编辑
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

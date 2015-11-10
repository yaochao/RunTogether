//
//  RTRegisterController.m
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import "RTRegisterController.h"
#import "RTProfileUserModel.h"
#import "RTNetworkTools.h"
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "MBProgressHUD+MJ.h"

@interface RTRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSDictionary *responseObject;
@end


@implementation RTRegisterController


#pragma mark - btnClick
- (IBAction)registerBtnClick:(id)sender {
    // 判空
    if ([_username.text isEqual:@""]) {
        [MBProgressHUD showError:@"请输入用户名"];
        return;
    }
    
    if ([_phoneNum.text isEqual:@""]) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    
    if ([_password.text isEqual:@""]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    // 请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = _username.text;
    params[@"password"] = _password.text;
    params[@"phone"] = _phoneNum.text;
    [MBProgressHUD showMessage:@"请稍后..."];
    [RTNetworkTools postDataWithParams:params interfaceType:@"users" success:^(NSDictionary *responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@", responseObject);
        _responseObject = responseObject;
        [MBProgressHUD showSuccess:[NSString stringWithFormat:@"注册成功,欢迎你%@", responseObject[@"name"]]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"网络错误 - %@", error);
        // 提示网络有问题
        NSString *errorMsg = [NSString stringWithFormat:@"请检查您的网络连接\n错误代码 %li", error.code];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"网络错误" message:errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];

    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义左边返回的按钮
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backarrow_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
}

#pragma mark - 自定义左边返回的按钮
- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

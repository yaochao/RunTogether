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
    if ([_username.text isEqual:NSLocalizedString(@"", nil)]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入用户名", nil)];
        return;
    }
    
    if ([_phoneNum.text isEqual:@""]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入手机号", nil)];
        return;
    }
    
    if ([_password.text isEqual:NSLocalizedString(@"", nil)]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入密码", nil)];
        return;
    }
    
    // 请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"name"] = _username.text;
    params[@"password"] = _password.text;
    params[@"phone"] = _phoneNum.text;
    [MBProgressHUD showMessage:NSLocalizedString(@"请稍后...", nil)];
    [RTNetworkTools postDataWithParams:params interfaceType:RTRegisterType success:^(NSDictionary *responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@", responseObject);
        _responseObject = responseObject;
        [MBProgressHUD showSuccess:[NSString stringWithFormat:NSLocalizedString(@"注册成功,欢迎你%@", nil), responseObject[@"name"]]];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        NSLog(@"网络错误 - %@", error);
        // 提示网络有问题
        NSString *errorMsg = [NSString stringWithFormat:NSLocalizedString(@"请检查您的网络连接\n错误代码 %li", nil), error.code];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"网络错误", nil) message:errorMsg delegate:nil cancelButtonTitle:NSLocalizedString(@"确定", nil) otherButtonTitles:nil, nil];
        [alertView show];

    }];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义左边返回的按钮
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:NSLocalizedString(@"backarrow_icon", nil)] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
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

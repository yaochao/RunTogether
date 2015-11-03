//
//  RTLoginController.m
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import "RTLoginController.h"

@interface RTLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSDictionary *responseObject;
@end

@implementation RTLoginController

#pragma mark - btnClick
- (IBAction)loginBtnClick:(id)sender {
    // 判空
    if ([_username.text isEqual:@""]) {
        [MBProgressHUD showError:@"请输入手机号码"];
        return;
    }
    
    if ([_password.text isEqual:@""]) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    // 请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = _username.text;
    params[@"password"] = _password.text;
  
    [MBProgressHUD showMessage:@"请稍后..."];
    [RTNetworkTools postDataWithParams:params interfaceType:@"sessions" success:^(NSDictionary *responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@", responseObject);
        _responseObject = responseObject;
        [MBProgressHUD showSuccess:@"登录成功,欢迎你"];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
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

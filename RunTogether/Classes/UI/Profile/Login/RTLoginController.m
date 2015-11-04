//
//  RTLoginController.m
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import "RTLoginController.h"
#import "RTKeyChainTools.h"

@interface RTLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSDictionary *responseObject;
@end

@implementation RTLoginController

#pragma mark - btnClick
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
    
    // 请求网络
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"phone"] = _phone.text;
    params[@"password"] = _password.text;
  
    [MBProgressHUD showMessage:@"请稍后..."];
    [RTNetworkTools postDataWithParams:params interfaceType:@"sessions" success:^(NSDictionary *responseObject) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@", responseObject);
        _responseObject = responseObject;
        [MBProgressHUD showSuccess:@"登录成功,欢迎你"];
        // 存储信息到钥匙串
//        [RTKeyChainTools savePhone:_phone.text];
//        [RTKeyChainTools saveRememberToken:responseObject[@"remember_token"]];
//        [RTKeyChainTools saveUserId:responseObject[@"user_id"]];
//        [RTKeyChainTools saveSessionKey:responseObject[@"session_key"]];
        if ([RTKeyChainTools savePhone:_phone.text]) {
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

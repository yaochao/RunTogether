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
#import "MaxwellClient.h"
#import "RTMaxwellListener.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>




@interface RTLoginController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) NSDictionary *responseObject;
@property (nonatomic, strong) RTLocationController *locationVC;
@property (nonatomic, strong) MaxwellClient *maxwellClient;
@end

@implementation RTLoginController

#pragma mark - btnClick
// 返回
- (IBAction)cancelBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 密码登录
- (IBAction)loginBtnClick:(id)sender {
    // 判空
    if ([_phone.text isEqual:@""]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入手机号码", nil)];
        return;
    }
    if ([_password.text isEqual:@""]) {
        [MBProgressHUD showError:NSLocalizedString(@"请输入密码", nil)];
        return;
    }
    
    [MBProgressHUD showMessage:NSLocalizedString(@"正在登录...", nil)];

    // 密码登录
    [self loginWithPhone:_phone.text proof:_password.text type:RTLoginPasswordType];
    
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
        } else {
            [MBProgressHUD showSuccess:NSLocalizedString(@"后台自动登录成功", nil)];
            NSLog(@"后台自动登录成功");
        }
        // 打开Maxwell
        [self startMaxwellClient];
    
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


#pragma mark - 启动Maxwell
- (void)startMaxwellClient {
    // 先停止
    [self stopMaxwellClient];
    // 加载Maxwell
    RTMaxwellListener *listener = [[RTMaxwellListener alloc] init];
    _maxwellClient = [[MaxwellClient alloc] initWithEndpoint:[RTKeyChainTools getEndpoint] withUserId:[NSNumber numberWithLongLong:[[RTKeyChainTools getUserId] longLongValue]] withSessionKey:[RTKeyChainTools getSessionKey] withListener:listener];
    // 启动Maxwell
    [_maxwellClient start];
    NSLog(@"Maxwell启动了");
}

#pragma mark - 关闭Maxwell
- (void)stopMaxwellClient {
    //
    if (_maxwellClient == nil) {
        return;
    }
    [_maxwellClient stop];
    _maxwellClient = nil;
    NSLog(@"maxwell关闭了");
}

#pragma mark - MaxwellListener超时
- (void)onTimeoutNotification {
    if (![[RTKeyChainTools getLastNetworkReachabilityStatus] isEqualToString:@"unconnected"]) {
        [self tokenLogin];
    }
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

#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 注册通知
    [RTNotificationCenter addObserver:self selector:@selector(reachabilityDidChange:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [RTNotificationCenter addObserver:self selector:@selector(onTimeoutNotification) name:@"MaxwellTimeoutNotification" object:nil];
}

#pragma mark 触摸空白结束编辑
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


#pragma mark didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc
- (void)dealloc {
    [RTNotificationCenter removeObserver:self];
}


@end

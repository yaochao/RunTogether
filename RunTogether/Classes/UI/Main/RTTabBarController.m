//
//  RTTabBarController.m
//  RunTogether
//
//  Created by yaochao on 15/11/17.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTTabBarController.h"
#import "RTLoginController.h"
#import "RTKeyChainTools.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface RTTabBarController ()
@property (nonatomic , strong) RTLoginController *loginController;
@end

@implementation RTTabBarController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [RTNotificationCenter addObserver:self selector:@selector(receivedLoginNotification:) name:RTLoginNotification object:nil];
    // 每次进来的时候自动登录，先清空token
    [RTKeyChainTools removeRememberToken];
}

// 登录通知调用
- (void)receivedLoginNotification:(NSNotification *)notification {
    NSLog(@"收到了登录通知%@", notification.userInfo[RTLoginTypeKey]);
    // 显式
    if ([notification.userInfo[RTLoginTypeKey] integerValue] == RTLoginPasswordType) {
        [self presentViewController:self.loginController animated:YES completion:^{
            NSLog(@"present loginController...");
        }];
        return;
    }
    // 隐式
    if ([notification.userInfo[RTLoginTypeKey] integerValue] == RTLoginTokenType) {
        [self.loginController tokenLogin];
        return;
    }
}


#pragma mark - getter(懒加载)
- (RTLoginController *)loginController {
    if (_loginController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTLogin" bundle:nil];
        _loginController = [sb instantiateInitialViewController];
    }
    return _loginController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

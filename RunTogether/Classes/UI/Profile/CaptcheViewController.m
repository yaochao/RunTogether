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
@interface CaptcheViewController ()
@property (weak, nonatomic) IBOutlet UITextField *captcheTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonAction:(UIButton *)sender;
- (IBAction)captcheTextAction:(UITextField *)sender;
@property (weak, nonatomic) IBOutlet UILabel *nextLable;
@property (strong, nonatomic) NSMutableDictionary *captcheDic;
@end

@implementation CaptcheViewController{
    int i;
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
- (IBAction)nextButtonAction:(UIButton *)sender {
    if (i == 0) {
        CGFloat width = self.nextLable.frame.size.width;
        CGFloat x = self.nextLable.frame.origin.x;
        CGFloat y = self.nextLable.frame.origin.y;
        CGFloat height = self.nextLable.frame.size.height;
        [self.nextLable setFrame:CGRectMake(x, y, 0, height)];
        [UIView animateWithDuration:3 animations:^{
            [self.nextLable setFrame:CGRectMake(x, y, width, height)];
        }];
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
        }];
        i++;
    }else{
        QueuingViewController* queuingVC = [[QueuingViewController alloc]init];
        queuingVC.user_id = self.captcheDic[@"user_id"];
        [self.navigationController pushViewController:queuingVC animated:YES];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    i = 0;
}
- (IBAction)captcheTextAction:(UITextField *)sender {
    if (sender.text.length == RTSecurityCodeLength) {
        self.nextButton.userInteractionEnabled = YES;
        self.nextLable.alpha = 1;
    }else{
        self.nextButton.userInteractionEnabled = NO;
        self.nextLable.alpha = 0.4;
    }
}
@end

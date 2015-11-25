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
@interface RTLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UIButton *checkoutButton;
@property (weak, nonatomic) IBOutlet UILabel *checkoutLable;
- (IBAction)phoneNumerAction:(UITextField *)sender;
- (IBAction)checkoutButtonAction:(UIButton *)sender;

@end

@implementation RTLoginViewController{
    int i ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.checkoutButton.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor blackColor])];
    self.checkoutButton.userInteractionEnabled = NO;
    self.checkoutLable.alpha = 0.4;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (IBAction)phoneNumerAction:(UITextField *)sender {
    if (sender.text.length >= 11) {
        self.checkoutButton.userInteractionEnabled = YES;
        self.checkoutLable.alpha = 1;
    }else{
        self.checkoutButton.userInteractionEnabled = NO;
        self.checkoutLable.alpha = 0.4;
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    i = 0;
}
- (IBAction)checkoutButtonAction:(UIButton *)sender {
    if (i == 0) {
        [self.checkoutLable setFrame:CGRectMake(82, 241, 0, 44)];
        [UIView animateWithDuration:3 animations:^{
            [self.checkoutLable setFrame:CGRectMake(82, 241, 217, 44)];
        }];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"phone"] = self.phoneNumberTextField.text;
        NSString *interface = @"security_codes";
        [RTNetworkTools postDataWithParams:params interfaceType:interface success:^(id responseObject) {
            NSLog(@"登陆成功- %@",responseObject);
        } failure:^(NSError *error) {
            NSLog(@"登陆失败- %@\n%@",error,error.userInfo[kErrorResponseObjectKey]);
        }];
        i++;
    }else{
        CaptcheViewController* captcheVC = [[CaptcheViewController alloc]init];
        [self.navigationController pushViewController:captcheVC animated:YES];
        captcheVC.phone = self.phoneNumberTextField.text;
    }
}
@end

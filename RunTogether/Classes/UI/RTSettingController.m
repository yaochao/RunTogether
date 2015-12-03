//
//  RTSettingController.m
//  RunTogether
//
//  Created by yaochao on 15/11/25.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTSettingController.h"
#import "RTNetworkTools.h"
#import "RTKeyChainTools.h"

@interface RTSettingController ()

@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;
@end

@implementation RTSettingController


#pragma mark - logout
- (IBAction)logoutBtnClick:(id)sender {
    [RTNetworkTools deleteDataWithParams:nil interfaceType:RTLogoutType success:^(id responseObject) {
        NSLogSuccessResponse;
    } failure:^(NSError *error) {
        NSLogErrorResponse;
    }];
    // 清空钥匙串
    [RTKeyChainTools removeAll];
    // 关闭lisenner
    [RTNotificationCenter postNotificationName:RTStopMaxwellNotification object:nil];
    // POP到最顶
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  switch
 */
- (IBAction)switchToggle:(UISwitch *)switchBtn {
    NSLog(@"%@", switchBtn.isOn ? @"switch on" : @"switch off");
}



#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
}

@end

//
//  RTLobbyController.m
//  RunTogether
//
//  Created by yaochao on 15/11/16.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTLobbyController.h"
#import "RTLoginController.h"
#import "RTKeyChainTools.h"
#import "MBProgressHUD+MJ.h"
#import "RTNetworkTools.h"
#import "RTGameStartedBodyModel.h"
#import "RTGameRoomController.h"
#import "RTLocationController.h"

#define dataSource  @[@1000, @3000, @5000, @10000]
#define numberOfComponents 1
#define cancelMatch 101

@interface RTLobbyController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *isLogin;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *logoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;

@property (nonatomic, strong) RTLoginController *loginController;
@property (nonatomic, strong) RTGameRoomController *gameRommController;
@property (nonatomic, strong) RTLocationController *locationController;
@property (nonatomic, strong) NSDictionary *responseObject;
@end

@implementation RTLobbyController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 数据源
    self.data = dataSource;
    [self.pickerView selectRow:1 inComponent:0 animated:YES];
    // 注册通知
    [RTNotificationCenter addObserver:self selector:@selector(receivedPush:) name:RTGameStartedNotification object:nil];
}

#pragma mark -
- (void)receivedPush:(NSNotification *)notification {
    // 模态出GameRoomController
    RTGameStartedBodyModel *bodyModel = notification.userInfo[RTGameStartedKey];
    self.gameRommController.bodyModel = bodyModel;
    [self presentViewController:self.gameRommController animated:YES completion:nil];
    // 对本身控件的处理
    // ...
}


#pragma mark - datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return numberOfComponents;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}


#pragma mark - delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@ m", self.data[row]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"select %li row", (long)row);
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}


#pragma mark - button click
- (IBAction)logoutBtnClick:(UIBarButtonItem *)sender {
    [RTKeyChainTools removeRememberToken];
    [MBProgressHUD showSuccess:@"您已退出登录"];
}

- (IBAction)puchBtnClick:(id)sender {
    [self.navigationController presentViewController:self.gameRommController animated:YES completion:nil];
    // 打开定位
    [self.locationController startLocationBtnClick:nil];
}

- (IBAction)goClick:(UIButton *)sender {
    NSLog(@"go");
    // CancelMatchBtn
    if (sender.tag == cancelMatch) {
        // 请求网络，取消匹配
        NSString *interfaceType = [NSString stringWithFormat:@"preparations/%@", self.responseObject[@"id"]];
        [RTNetworkTools deleteDataWithParams:nil interfaceType:interfaceType success:^(NSDictionary *responseObject) {
            // 打开定位
            [self.locationController stopLocationBtnClick:nil];
            
            NSLog(@"%@", responseObject);
            [sender setTitle:@"Match" forState:UIControlStateNormal];
            [sender setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            sender.tag = 100;
        } failure:^(NSError *error) {
            NSLog(@"error body - %@", error.userInfo[kErrorResponseObjectKey]);
        }];
        return;
    }
    
    // MatchBtn
    // 判断是否已登录
    if ([RTKeyChainTools getRememberToken]) {
        // 已登录
        // 关闭定位
        [self.locationController startLocationBtnClick:nil];
        // 请求网络，进行匹配
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"distance"] = @([self.data[[self.pickerView selectedRowInComponent:0]] intValue]);
        [RTNetworkTools postDataWithParams:params interfaceType:RTPreparationsType success:^(NSDictionary *responseObject) {
            NSLog(@"%@", responseObject);
            self.responseObject = responseObject;
        } failure:^(NSError *error) {
            NSString *errorbody = error.userInfo[kErrorResponseObjectKey];
            NSLog(@"error body - %@",errorbody);
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@", errorbody]];
        }];
        return ;
    }
    // 未登录
    [RTNotificationCenter postNotificationName:RTLoginNotification object:nil userInfo:@{RTLoginTypeKey : @(RTLoginPasswordType)}];
}


#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter
- (void)setResponseObject:(NSDictionary *)responseObject {
    _responseObject = responseObject;
    // 处理
    // 返回成功
    if (!responseObject[@"errorcode"]) {
        [self.goBtn setTitle:@"CancelMatch" forState:UIControlStateNormal];
        [self.goBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        self.goBtn.tag = cancelMatch; // tag = 101，取消匹配
        return;
    }
    // 返回失败
    // ...
}

#pragma mark - getter
- (RTGameRoomController *)gameRommController {
    if (_gameRommController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTGameRoom" bundle:nil];
        _gameRommController = [sb instantiateViewControllerWithIdentifier:@"gameRoomController"];
//        _gameRommController = [sb instantiateInitialViewController];
    }
    return _gameRommController;
}

- (RTLocationController *)locationController {
    if (_locationController == nil) {
        _locationController = [[RTLocationController alloc] init];
    }
    return _locationController;
}


@end

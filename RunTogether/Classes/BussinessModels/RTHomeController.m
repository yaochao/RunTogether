//
//  RTHomeController.m
//  RunTogether
//
//  Created by yaochao on 15/11/25.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTHomeController.h"
#import "RTSettingController.h"
#import "RTMyHistoryController.h"

@interface RTHomeController ()

@property (weak, nonatomic) IBOutlet UIImageView *avartaIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *levelLbl;
@property (nonatomic, strong) RTSettingController *settingController;
@property (nonatomic, strong) RTMyHistoryController *historyController;
@end

@implementation RTHomeController

#pragma mark - BtnClick
/**
 *  个人历史记录
 *
 *  @param sender button
 */
- (IBAction)myHistoryBtnClick:(id)sender {
    [self.navigationController pushViewController:self.historyController animated:YES];
}

/**
 *  入赛
 *
 *  @param sender button
 */
- (IBAction)enterGame:(id)sender {
}

/**
 *  设置
 *
 *  @param sender button
 */
- (IBAction)settingBtnClick:(id)sender {
    [self.navigationController pushViewController:self.settingController animated:YES];
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - getter
- (RTSettingController *)settingController {
    if (_settingController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTSetting" bundle:nil];
        _settingController  = [sb instantiateInitialViewController];
    }
    return _settingController;
}

- (RTMyHistoryController *)historyController {
    if (_historyController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTMyHistory" bundle:nil];
        _historyController = [sb instantiateInitialViewController];
    }
    return _historyController;
}


#pragma mark - setter

@end

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
#import "RTNetworkTools.h"
#import "RTKeyChainTools.h"
#import "RTGamePropertiesModel.h"
#import "RTUserInfoModel.h"
#import <MJExtension/MJExtension.h>
#import <UIImageView+WebCache.h>
#import "RTStartingLineController.h"
#import "MaxwellClient.h"

@interface RTHomeController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *levelLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalDistanceLbl;
@property (nonatomic, weak) RTSettingController *settingController;
@property (nonatomic, weak) RTMyHistoryController *historyController;
@property (nonatomic, weak)RTStartingLineController *startingLineController;
@property (nonatomic, strong) RTGamePropertiesModel *gamePropertiesModel;
@property (nonatomic, strong) RTUserInfoModel *userInfoModel;
@property (nonatomic, strong) MaxwellClient *maxwellClient;
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
    [self.navigationController pushViewController:self.startingLineController animated:YES];
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
    [self loadData];
    // 打开Maxwell
    [self startMaxwellClient];
    // 注册通知
    [RTNotificationCenter addObserver:self selector:@selector(receivedStopMaxwell) name:RTStopMaxwellNotification object:nil];
}


#pragma mark - receivedStopMaxwell
- (void)receivedStopMaxwell {
    [self stopMaxwellClient];
}

#pragma mark - 启动Maxwell
- (void)startMaxwellClient {
    // 先停止
    [self stopMaxwellClient];
    // 启动Maxwell
    [self.maxwellClient start];
    NSLog(@"Maxwell启动了");
}

#pragma mark - 关闭Maxwell
- (void)stopMaxwellClient {
    if (_maxwellClient != nil) {
        [_maxwellClient stop];
        _maxwellClient = nil;
    }
    NSLog(@"maxwell关闭了");
}

#pragma mark - viewViewAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // do somthing
    // let the avatar become circle
    self.avatarIV.layer.cornerRadius = self.avatarIV.frame.size.width / 2;
    self.avatarIV.layer.masksToBounds = YES;
}


#pragma mark - 网络请求
- (void)loadData {
    // load user_info
    NSString *interface = [NSString stringWithFormat:@"users/%@", [RTKeyChainTools getUserId]];
    [RTNetworkTools getDataWithParams:nil interfaceType:interface success:^(id responseObject) {
        NSLogSuccessResponse;
        RTUserInfoModel *userInfoModel = [RTUserInfoModel objectWithKeyValues:responseObject];
        self.userInfoModel = userInfoModel;
    } failure:^(NSError *error) {
        NSLogErrorResponse;
    }];
    
    // load game_properties
    NSString *interface2 = [NSString stringWithFormat:@"users/%@/game_properties", [RTKeyChainTools getUserId]];
    [RTNetworkTools getDataWithParams:nil interfaceType:interface2 success:^(id responseObject) {
        NSLogSuccessResponse;
        RTGamePropertiesModel *gamePropertiesModel = [RTGamePropertiesModel objectWithKeyValues:responseObject];
        self.gamePropertiesModel = gamePropertiesModel;
    } failure:^(NSError *error) {
        NSLogErrorResponse;
    }];
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

- (RTStartingLineController *)startingLineController {
    if (_startingLineController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTStartingLine" bundle:nil];
        _startingLineController = [sb instantiateInitialViewController];
    }
    return _startingLineController;
}


#pragma mark - setter
- (void)setGamePropertiesModel:(RTGamePropertiesModel *)gamePropertiesModel {
    _gamePropertiesModel = gamePropertiesModel;
    // 赋值
    // 等级
    self.levelLbl.text = [NSString stringWithFormat:@"%li级", gamePropertiesModel.level];
    // 勋章
#warning TODO
    // 总里程
    self.totalDistanceLbl.text = [NSString stringWithFormat:@"%liKM", gamePropertiesModel.total_distance];
}

- (void)setUserInfoModel:(RTUserInfoModel *)userInfoModel {
    _userInfoModel = userInfoModel;
    // 赋值/
    // 头像
    [self.avatarIV sd_setImageWithURL:[NSURL URLWithString:userInfoModel.avatar_url] placeholderImage:nil];
    // 昵称
    self.nameLbl.text = userInfoModel.name;
}


#pragma mark - getter
- (MaxwellClient *)maxwellClient {
    // 加载Maxwell
    if (_maxwellClient == nil) {
        RTMaxwellListener *listener = [[RTMaxwellListener alloc] init];
        _maxwellClient = [[MaxwellClient alloc] initWithEndpoint:[RTKeyChainTools getEndpoint] withUserId:[NSNumber numberWithLongLong:[[RTKeyChainTools getUserId] longLongValue]] withSessionKey:[RTKeyChainTools getSessionKey] withListener:listener];
    }
    return _maxwellClient;
}


#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
}

@end

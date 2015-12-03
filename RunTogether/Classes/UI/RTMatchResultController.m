//
//  RTMatchResultController.m
//  RunTogether
//
//  Created by yaochao on 15/12/1.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTMatchResultController.h"
#import "RTMatchResultCell.h"
#import "RTNetworkTools.h"
#import "RTGameStartedBodyModel.h"
#import "RTGameStartedBodyUsersModel.h"
#import "UITableView+Wave.h"
#import "NSObject+UserDefaults.h"

#define RowHeight 60

@interface RTMatchResultController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectedDistanceLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *users;
@end

@implementation RTMatchResultController

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning TODO 测试
    return self.users.count == 0 ? 5 : self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#warning TODO 测试
    if (self.users.count == 0) {
        return [tableView dequeueReusableCellWithIdentifier:@"RTMatchResultCell"];
    }
    RTGameStartedBodyUsersModel *userModel = self.users[indexPath.row];
    RTMatchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMatchResultCell"];
    cell.userModel = userModel;
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RowHeight;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 当cell完全显示完之后
    if (indexPath.row == self.users.count - 1) {
        // 开始倒计时
        [self countDown];
    }
    NSLog(@"end display cell %li", indexPath.row);

}


#pragma mark - 倒计时5秒
- (void)countDown {
    [self.delegate matchResult:self didFinishedMatch:self.users];
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 加载网络数据
    [self loadData];
    // 注册游戏开始的通知
    [RTNotificationCenter addObserver:self selector:@selector(receivedGameStartedNotification:) name:RTGameStartedNotification object:nil];
}

- (void)receivedGameStartedNotification:(NSNotification *)notification {
    RTGameStartedBodyModel *startedBodyModel = notification.userInfo[RTGameStartedKey];
    self.users = startedBodyModel.users;
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
    [RTNotificationCenter removeObserver:self];
}

#pragma mark - 加载网络数据
- (void)loadData {
    // 请求网络，进行匹配
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"distance"] = [NSObject getValueWithKey:SELECTED_DISTANCE];
    NSLog(@"SELECTED_DISTANCE:%@", [NSObject getValueWithKey:SELECTED_DISTANCE]);
    [RTNetworkTools postDataWithParams:params interfaceType:RTPreparationsType success:^(NSDictionary *responseObject) {
        NSLogSuccessResponse;
    } failure:^(NSError *error) {
        NSLogErrorResponse;
    }];
}


#pragma mark - setter
- (void)setUsers:(NSArray *)users {
    _users = users;
    // 刷新表格
    [self.tableView reloadDataAnimateWithWave:RightToLeftWaveAnimation];
}


@end

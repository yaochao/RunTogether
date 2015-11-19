//
//  RTGameRoomController.m
//  RunTogether
//
//  Created by yaochao on 15/11/19.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTGameRoomController.h"
#import "RTPlayerCell.h"
#import "RTGameOverBodyModel.h"
#import "RTGameOverBodyRankModel.h"
#import "RTGameStartedBodyUsersModel.h"
#import "MBProgressHUD+MJ.h"
#import "RTGameRankChangedBodyModel.h"


@interface RTGameRoomController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *showLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) RTGameOverBodyModel *overBodyModel;
@property (nonatomic, strong) RTGameRankChangedBodyModel *changedBodyModel;
@property (nonatomic, strong) NSMutableArray *users;
@end

@implementation RTGameRoomController

#pragma mark - dataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count == 0 ? 20 : self.users.count;
}

- (RTPlayerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell
    RTPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell"];
    // data
    cell.userModel = self.users[indexPath.row];
    cell.rankLbl.text = [NSString stringWithFormat:@"NO.%li", indexPath.row + 1];
    return cell;
}

#pragma mark - delegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

#pragma mark - btnClick
- (IBAction)quitBtnClick:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // 自身退出后的处理...内存等
        // ...
    }];
}
// 第二个退出
- (IBAction)quit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // 自身退出后的处理...内存等
        // ...
    }];
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 注册通知
    [RTNotificationCenter addObserver:self selector:@selector(receivedOverPush:) name:RTGameOverNotification object:nil];
    [RTNotificationCenter addObserver:self selector:@selector(receivedChangePush:) name:RTGameRankChangedNotification object:nil];
    // 只要是创建了本控制器说明开始了比赛
    self.showLbl.text = @"比赛进行中";
}

#pragma mark - 处理通知
#warning 可以重构
// 比赛结束
- (void)receivedOverPush:(NSNotification *)notification {
    
    self.overBodyModel = notification.userInfo[RTGameOverKey];
    // showLbl辅值
    self.showLbl.text = @"比赛已结束";
}

// 排名发生变化
- (void)receivedChangePush:(NSNotification *)notification {
    
    self.changedBodyModel = notification.userInfo[RTGameRankChangedKey];
    // showLbl辅值
    [MBProgressHUD showSuccess:@"排名发生了变化..."];
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setter方法
#warning 以下三个可以重构
// 比赛开始
- (void)setBodyModel:(RTGameStartedBodyModel *)bodyModel {
    _bodyModel = bodyModel;
    // 给自身数组赋值，刷新表格
#warning 这个警告没事
    self.users = bodyModel.users;
    [self.tableView reloadData];
}

// 比赛结束
- (void)setOverBodyModel:(RTGameOverBodyModel *)overBodyModel {
    _overBodyModel = overBodyModel;
    // 给自身数组赋值，刷新表格
    NSMutableArray *users = [NSMutableArray array];
    for (int i = 0; i < overBodyModel.rank.count; i++) {
        RTGameOverBodyRankModel *  rankModel = overBodyModel.rank[i];
        RTGameStartedBodyUsersModel *userModel = rankModel.user;
        [users addObject:userModel];
    }
    self.users = users;
    [self.tableView reloadData];
}

// 排名变化
- (void)setChangedBodyModel:(RTGameRankChangedBodyModel *)changedBodyModel {
    _changedBodyModel = changedBodyModel;
    // 给自身数组赋值，刷新表格
    NSMutableArray *users = [NSMutableArray array];
    for (int i = 0; i < changedBodyModel.rank.count; i++) {
        RTGameOverBodyRankModel *  rankModel = changedBodyModel.rank[i];
        RTGameStartedBodyUsersModel *userModel = rankModel.user;
        [users addObject:userModel];
    }
    self.users = users;
    [self.tableView reloadData];
}

@end

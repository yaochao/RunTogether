//
//  RTMyHistoryController.m
//  RunTogether
//
//  Created by yaochao on 15/11/25.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTMyHistoryController.h"
#import "RTMyHistoryCell.h"
#import "RTMyHistoryModel.h"
#import "RTKeyChainTools.h"
#import "RTNetworkTools.h"
#import <MJExtension/MJExtension.h>

@interface RTMyHistoryController ()

@property (nonatomic, strong) NSMutableArray *modelArr;
@end

@implementation RTMyHistoryController


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadDataWithPS:10 PN:1];
}


#pragma mark - 请求网络
- (void)loadDataWithPS:(int)ps PN:(int)pn {
    NSString *interface = [NSString stringWithFormat:@"users/%@/game_summaries?ps=%i&pn=%i", [RTKeyChainTools getUserId], ps, pn];
//    NSString *interface = [NSString stringWithFormat:@"users/%@/game_summaries?ps=%i&pn=%i", @10000, ps, pn];

    [RTNetworkTools getDataWithParams:nil interfaceType:interface success:^(id responseObject) {
        NSLogSuccessResponse;
        // JSON->MODEL
        NSMutableArray *modelArr = [RTMyHistoryModel objectArrayWithKeyValuesArray:responseObject];
        self.modelArr = modelArr;
    } failure:^(NSError *error) {
        NSLogErrorResponse;
    }];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count == 0 ? 20 : self.modelArr.count;
}


#pragma mark - Table view delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#warning TODO
    if (self.modelArr.count == 0) {
        // cell
        RTMyHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHistoryCell"];
        return cell;
    }
    
#warning TODO
    if (self.modelArr.count == 0) {
        RTMyHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHistoryCell"];
        return cell;
    }
    // model
    RTMyHistoryModel *myHistoryModel = self.modelArr[indexPath.row];
    // cell
    RTMyHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myHistoryCell"];
    // Configure the cell...
    cell.myHistoryModel = myHistoryModel;
    //
    return cell;
}


#pragma mark - setter
- (void)setModelArr:(NSMutableArray *)modelArr {
    _modelArr = modelArr;
    // 刷新表格
    [self.tableView reloadData];
}

#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
}

@end

//
//  RTGameRoomController.m
//  RunTogether
//
//  Created by yaochao on 15/11/19.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTGameRoomController.h"
#import "RTPlayerCell.h"


@interface RTGameRoomController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *showLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RTGameRoomController

#pragma mark - dataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bodyModel.users.count == 0 ? 20 : self.bodyModel.users.count;
}

- (RTPlayerCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // cell
    RTPlayerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playerCell"];
    // data
    cell.userModel = self.bodyModel.users[indexPath.row];
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

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

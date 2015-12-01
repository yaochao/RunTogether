//
//  RTMatchResultController.m
//  RunTogether
//
//  Created by yaochao on 15/12/1.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTMatchResultController.h"
#import "RTMatchResultCell.h"

@interface RTMatchResultController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *selectedDistanceLbl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RTMatchResultController

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 拿到model
    // 拿到cell
    RTMatchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RTMatchResultCell"];
    // 赋值
#warning TODO
    return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

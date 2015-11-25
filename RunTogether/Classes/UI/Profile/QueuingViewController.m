//
//  QueuingViewController.m
//  loading
//
//  Created by 赵欢 on 15/11/25.
//  Copyright © 2015年 赵欢. All rights reserved.
//

#import "QueuingViewController.h"
@interface QueuingViewController ()

@end

@implementation QueuingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc]initWithTitle:@"切换账号" style:UIBarButtonSystemItemDone target:self action:@selector(changeNumber)];
    self.navigationItem.leftBarButtonItem = leftButton;
        // Do any additional setup after loading the view from its nib.
}
- (void)changeNumber{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


//
//  RTLoadingViewController.m
//  loading
//
//  Created by 赵欢 on 15/11/25.
//  Copyright © 2015年 赵欢. All rights reserved.
//

#import "RTLoadingViewController.h"
#import "RTLoginViewController.h"

@interface RTLoadingViewController ()
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
- (IBAction)beginButtonAction:(id)sender;

@end

@implementation RTLoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.beginButton.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor blackColor])];
    
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)beginButtonAction:(id)sender {
    RTLoginViewController *loginVC = [[RTLoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
@end

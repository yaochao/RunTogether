//
//  RTLoginController.m
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import "RTLoginController.h"

@interface RTLoginController ()

@end

@implementation RTLoginController

#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark 触摸空白结束编辑
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

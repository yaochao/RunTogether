//
//  RTRegisterController.m
//  
//
//  Created by yaochao on 15/11/2.
//
//

#import "RTRegisterController.h"

@interface RTRegisterController ()

@end

@implementation RTRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 自定义左边返回的按钮
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backarrow_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick)];
}

#pragma mark - 自定义左边返回的按钮
- (void)leftBarButtonItemClick {
    [self.navigationController popViewControllerAnimated:YES];
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

//
//  QueuingViewController.m
//  loading
//
//  Created by 赵欢 on 15/11/25.
//  Copyright © 2015年 赵欢. All rights reserved.
//

#import "QueuingViewController.h"
#import "RTNetworkTools.h"
#import "RTGamePropertiesModel.h"
#import "RTNameViewController.h"
#import <pop/POP.h>
#import <MJExtension/MJExtension.h>
@interface QueuingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *beforeMeLable;
@property (weak, nonatomic) IBOutlet UILabel *afterMeLable;
- (IBAction)queuingSuccess:(UIButton *)sender;
@end

@implementation QueuingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem* leftButton = [[UIBarButtonItem alloc]initWithTitle:@"切换账号" style:UIBarButtonSystemItemDone target:self action:@selector(changeNumber)];
    self.navigationItem.leftBarButtonItem = leftButton;
    NSString *interface = [NSString stringWithFormat:@"users/%@/game_properties", self.user_id];
    [RTNetworkTools getDataWithParams:nil interfaceType:interface success:^(id responseObject) {
        NSLogSuccessResponse;
        RTGamePropertiesModel* gameProperties = [RTGamePropertiesModel objectWithKeyValues:responseObject];
        
        // 数字动画效果
        [self.beforeMeLable pop_removeAllAnimations];
        POPBasicAnimation *beforeAnimation = [POPBasicAnimation animation];
        beforeAnimation.duration = 5;
        beforeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        POPAnimatableProperty *beforeProperty = [POPAnimatableProperty propertyWithName:@"before" initializer:^(POPMutableAnimatableProperty *prop) {
            // read value
            prop.readBlock = ^(id obj, CGFloat values[]) {
                values[0] = [[obj description] intValue];
            };
            // write value
            prop.writeBlock = ^(id obj, const CGFloat values[]) {
                [obj setText:[NSString stringWithFormat:@"%.f",values[0]]];
            };
            // dynamics threshold
            prop.threshold = 1;
        }];
        beforeAnimation.property = beforeProperty;
        beforeAnimation.fromValue = @(0);
        beforeAnimation.toValue = @(gameProperties.queuing_users_before_me);
        [self.beforeMeLable pop_addAnimation:beforeAnimation forKey:@"before"];
        
        [self.afterMeLable pop_removeAllAnimations];
        POPBasicAnimation *afterAnimation = [POPBasicAnimation animation];
        afterAnimation.duration = 5;
        afterAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        POPAnimatableProperty *afterProperty = [POPAnimatableProperty propertyWithName:@"after" initializer:^(POPMutableAnimatableProperty *prop) {
            // read value
            prop.readBlock = ^(id obj, CGFloat values[]) {
                values[0] = [[obj description] intValue];
            };
            // write value
            prop.writeBlock = ^(id obj, const CGFloat values[]) {
                [obj setText:[NSString stringWithFormat:@"%.f",values[0]]];
            };
            // dynamics threshold
            prop.threshold = 1;
        }];
        afterAnimation.property = afterProperty;
        afterAnimation.fromValue = @(0);
        afterAnimation.toValue = @(gameProperties.queuing_users_after_me);
        [self.afterMeLable pop_addAnimation:afterAnimation forKey:@"after"];
        
    } failure:^(NSError *error) {
        NSLogErrorResponse;
    }];
        // Do any additional setup after loading the view from its nib.
}
- (void)changeNumber{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)queuingSuccess:(UIButton *)sender {
    RTNameViewController* nameVC = [[RTNameViewController alloc]init];
    [self.navigationController pushViewController:nameVC animated:YES];
}
@end

//
//  RTNameViewController.m
//  RunTogether
//
//  Created by 赵欢 on 15/11/26.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTNameViewController.h"
#import "RTAvatarViewController.h"

@interface RTNameViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)changeNameAction:(UITextField *)sender;
- (IBAction)nextButtonAction:(UIButton *)sender;

@end

@implementation RTNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nextButton.userInteractionEnabled = NO;
    self.nextButton.alpha = 0.4;
}
- (IBAction)changeNameAction:(UITextField *)sender {
    self.nextButton.userInteractionEnabled = YES;
    self.nextButton.alpha = 1;
    if ([sender.text lengthOfBytesUsingEncoding:NSASCIIStringEncoding] > RTNameLength) {
        sender.text = [sender.text substringToIndex:RTNameLength];
    }
}
- (IBAction)nextButtonAction:(UIButton *)sender {
    RTAvatarViewController *avatarVC = [[RTAvatarViewController alloc]init];
    avatarVC.name = self.nameTextField.text;
    [self.navigationController pushViewController:avatarVC animated:YES];
}
@end

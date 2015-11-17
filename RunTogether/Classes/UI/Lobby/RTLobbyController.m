//
//  RTLobbyController.m
//  RunTogether
//
//  Created by yaochao on 15/11/16.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTLobbyController.h"
#import "NSObject+UserDefaults.h"

#define dataSource  @[@1, @3, @5, @10]
#define numberOfComponents 1

@interface RTLobbyController () <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, copy) NSString *isLogin;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation RTLobbyController

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // 数据源
    self.data = dataSource;
}


#pragma mark - datasource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.data.count;
}


#pragma mark - delegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@ km", self.data[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"select %li row", (long)row);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}


#pragma mark - button click
- (IBAction)goClick:(UIButton *)sender {
    NSLog(@"go");
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

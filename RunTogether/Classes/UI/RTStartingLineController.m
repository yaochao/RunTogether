//
//  RTStartingLineController.m
//  RunTogether
//
//  Created by yaochao on 15/11/30.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTStartingLineController.h"
#import "RTPrepareController.h"

#define DataSource @[@1000, @3000, @5000, @10000]
#define ComponentCount 1
#define RowHeight 50
#define CornerRadius 5

@interface RTStartingLineController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, weak) RTPrepareController *prepareController;
@end

@implementation RTStartingLineController

#pragma mark - dataSoure
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return ComponentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%@ M", self.dataSource[row]];
}


#pragma mark - delegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSLog(@"%@", self.dataSource[row]);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return RowHeight;
}


#pragma mark - btnClick
- (IBAction)startBtnClick:(id)sender {
    NSLog(@"start");
    [self.navigationController pushViewController:self.prepareController animated:YES];
}


#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataSource = DataSource;
    [self.pickerView selectRow:1 inComponent:0 animated:NO];
    // 圆角
    self.startBtn.layer.cornerRadius = CornerRadius;
    self.startBtn.layer.masksToBounds = YES;
}


#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (RTPrepareController *)prepareController {
    if (_prepareController == nil) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"RTPrepare" bundle:nil];
        _prepareController = [sb instantiateInitialViewController];
    }
    return _prepareController;
}

#pragma mark - dealloc
- (void)dealloc {
    NSLogDealloc;
}

@end

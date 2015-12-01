//
//  RTBlurEffectController.m
//  RunTogether
//
//  Created by yaochao on 15/11/28.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import "RTBlurEffectController.h"
#import "UIImage+ImageEffects.h"

@interface RTBlurEffectController ()

@property (nonatomic, strong) UIImageView *iv;

@property (weak, nonatomic) IBOutlet UILabel *helloLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *helloXCons;

@end

@implementation RTBlurEffectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.iv = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.iv.image = [UIImage imageNamed:@"sky"];
    self.tableView.backgroundView = self.iv;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = self.tableView.contentOffset.y;
    NSLog(@"%f", contentOffsetY);
    CGFloat alapha = 0;
    CGFloat fontSize = 0;
    CGFloat radius = 0;
    CGFloat constraintX = 0;
    if (contentOffsetY <= 0) {
        contentOffsetY = 0;
        alapha = 0;
        fontSize = 100;
        constraintX = 0;
    } else if (contentOffsetY <= 500) {
        radius = contentOffsetY / 100;
        alapha = 0.2 * (contentOffsetY / 500);
        fontSize = 100.0 * (1 - (contentOffsetY / 500));
        constraintX = (Screen_W - self.helloLbl.frame.size.width) / 2 * (contentOffsetY / 500);
    } else {
        return;
    }
    // 更改字体大小
    self.helloLbl.font = [UIFont systemFontOfSize:fontSize <= 30 ? 30 : fontSize];
    // 更改图片的位置
    self.helloXCons.constant = constraintX;
    // 开启子线程
    self.iv.image = [[UIImage imageNamed:@"sky"] applyBlurWithRadius:radius tintColor:[UIColor colorWithWhite:alapha alpha:alapha] saturationDeltaFactor:1.0 maskImage:nil];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        UIImage *img = [[UIImage imageNamed:@"sky"] applyBlurWithRadius:radius tintColor:[UIColor colorWithWhite:alapha alpha:alapha] saturationDeltaFactor:1.0 maskImage:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.iv.image = img;
//        });
//    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return Screen_H;
    }
    return 300;
}


@end

//
//  RTMatchResultController.h
//  RunTogether
//
//  Created by yaochao on 15/12/1.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RTMatchResultController;

@protocol RTMatchResultDelegate <NSObject>
@required
- (void)matchResult:(RTMatchResultController *)matchResultController didFinishedMatch:(NSArray *)users;
@end

@interface RTMatchResultController : UIViewController
@property (nonatomic, weak) id<RTMatchResultDelegate> delegate;
@end

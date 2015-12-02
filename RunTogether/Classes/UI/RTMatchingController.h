//
//  RTMatchingController.h
//  RunTogether
//
//  Created by yaochao on 15/12/1.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RTMatchingController;
@protocol RTMatchingDelegate <NSObject>
@required
- (void)matching:(RTMatchingController *)matchingController totalStep:(NSInteger)totalStep;
@end

@interface RTMatchingController : UIViewController
@property (nonatomic, weak) id<RTMatchingDelegate> delegate;
- (void)stopMonitor;
@end

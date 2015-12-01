//
//  RTDetectorController.h
//  RunTogether
//
//  Created by yaochao on 15/11/30.
//  Copyright © 2015年 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>

// 协议
@class RTDetectorController;
@protocol RTDetectorDelegate <NSObject>
@required
- (void)detector:(RTDetectorController *)detector didFinishedDetect:(NSMutableArray *)detectorResult;
@end

@interface RTDetectorController : UITableViewController
@property (nonatomic, weak) id<RTDetectorDelegate> delegate;

- (void)detectAll;
@end

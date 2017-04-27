//
//  YXSplitViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/19.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXSideMenuViewController_Pad.h"

@class YXSplitViewController;

@interface UIViewController (YXSplitViewController)

- (YXSplitViewController *)yxSplitViewController;

@end

@interface YXSplitViewController : UIViewController<YXSideMenuPadDelegate>
- (void)setupWithLeftVC:(UIViewController *)leftVC rightVCArray:(NSArray *)vcArray;

- (void)hideLeft;
- (void)showLeft;
@end

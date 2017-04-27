//
//  UIViewController+YXPresent.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (YXPresent)

- (void)yx_presentViewController:(UIViewController *)vc completion:(void (^)(void))completion;
- (void)yx_dismiss;

@end

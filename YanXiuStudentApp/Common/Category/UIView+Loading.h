//
//  UIView+Loading.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/4/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Loading)

- (void)nyx_startLoading;
- (void)nyx_stopLoading;
- (void)nyx_showToast:(NSString *)text;

@end

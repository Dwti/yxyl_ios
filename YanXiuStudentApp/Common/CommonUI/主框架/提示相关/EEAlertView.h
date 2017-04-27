//
//  EEAlertView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "AlertView.h"
#import "EEAlertContentBackgroundImageView.h"
#import "EEAlertTipImageView.h"
#import "EEAlertTitleLabel.h"
#import "EEAlertDottedLineView.h"
#import "EEAlertButton.h"

extern CGFloat const kDefaultContentViewWith;
typedef void(^ButtonActionBlock)(void);

@interface EEAlertView : AlertView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hideAlertWhenButtonTapped; // default is YES

- (void)addButtonWithTitle:(NSString *)title action:(ButtonActionBlock)buttonActionBlock;
- (void)show;
- (void)show:(BOOL)animated;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animated:(BOOL)animated;
@end

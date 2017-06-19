//
//  QAAlertView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "AlertView.h"
#import "QAAlertButton.h"

extern CGFloat const kQADefaultContentViewWith;
typedef void(^ButtonActionBlock)(void);

@interface QAAlertView : AlertView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, assign) BOOL hideAlertWhenButtonTapped; // default is YES

- (void)addButtonWithTitle:(NSString *)title style:(QAAlertActionStyle)style action:(ButtonActionBlock)buttonActionBlock;
- (void)show;
- (void)show:(BOOL)animated;
- (void)showInView:(UIView *)view;
- (void)showInView:(UIView *)view animated:(BOOL)animated;

@end

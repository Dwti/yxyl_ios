//
//  AlertView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/11/14.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AlertView;
typedef void (^LayoutBlock) (AlertView * view);

@interface AlertView : UIView
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIColor *maskColor;
@property (nonatomic, assign) BOOL hideWhenMaskClicked;

- (void)showWithLayout:(LayoutBlock)layoutBlock;
- (void)showInView:(UIView *)view withLayout:(LayoutBlock)layoutBlock;
- (void)hide;
@end

//
//  YXToastView.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  单个文本toast展示界面
 */
@interface YXToastView : UIView

@property (nonatomic, strong) NSString *text;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end

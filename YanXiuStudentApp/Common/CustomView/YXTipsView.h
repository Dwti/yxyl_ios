//
//  YXTipsView.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  返回结果展示界面，包含标题、文本、详情，比如：章节考点为空展示界面。
 */
@interface YXTipsView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *detailText;

- (void)show:(BOOL)animated;
- (void)hide:(BOOL)animated;
- (void)hide:(BOOL)animated afterDelay:(NSTimeInterval)delay;

@end

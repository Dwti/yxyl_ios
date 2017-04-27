//
//  YXLoginInputView.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/5/29.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXLoginInputView : UIView<UITextFieldDelegate>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *originalText;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, strong) NSDictionary *defaultTextAttributes;
@property (nonatomic, readonly) NSShadow *textShadow;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, copy) void(^rightClick)();
@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);

- (void)setFrontImage:(UIImage *)image;

- (void)setRightButtonImage:(UIImage *)image; //设置image
- (void)setRightButtonText:(NSString *)text; //设置text和frame
- (void)resetRightButtonText:(NSString *)text; //只重置text
- (void)setRightButtonBackgroundImage:(UIImage *)image forState:(UIControlState)state;
- (void)setRightButtonEnabled:(BOOL)enabled;
// 清空按钮
- (void)setRightClearButtonImages;

@end

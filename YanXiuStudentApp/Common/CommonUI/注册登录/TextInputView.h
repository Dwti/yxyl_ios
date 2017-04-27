//
//  TextInputView.h
//  YanXiuStudentApp
//
//  Created by FanYu on 11/2/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, strong) NSDictionary *defaultTextAttributes;
@property (nonatomic, readonly) NSShadow *textShadow;
@property (nonatomic, assign) NSInteger maxInputLength;

@property (nonatomic, copy) void(^rightClick)();
@property (nonatomic, copy) void(^textChangeBlock)(NSString *text);

@end

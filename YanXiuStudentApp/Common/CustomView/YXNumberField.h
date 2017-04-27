//
//  YXNumberField.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  班级号码等数字输入界面
 */
@interface YXNumberField : UIView<UITextFieldDelegate>

@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL secureTextEntry;
@property (nonatomic, assign) NSInteger numberCount;
@property (nonatomic, strong) UITextField *textField;


@end

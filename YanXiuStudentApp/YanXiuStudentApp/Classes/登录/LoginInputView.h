//
//  LoginInputView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/8.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginInputField : UITextField
@end

@interface LoginInputView : UIView
@property (nonatomic, strong) LoginInputField *textField;
@property (nonatomic, strong) NSString *placeHolder;
@end

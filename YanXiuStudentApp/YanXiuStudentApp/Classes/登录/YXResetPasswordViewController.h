//
//  YXResetPasswordViewController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/3.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoginBaseViewController.h"

@interface YXResetPasswordViewController : YXLoginBaseViewController

- (instancetype)initWithType:(YXPasswordOperationType)type phoneNumber:(NSString *)phoneNumber;

@end

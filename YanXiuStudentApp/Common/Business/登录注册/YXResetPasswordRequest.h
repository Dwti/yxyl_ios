//
//  YXResetPasswordRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

// 设置密码、重置密码
@interface YXResetPasswordRequest : YXPostRequest

@property (nonatomic, strong) NSString *mobile;   //手机号
@property (nonatomic, strong) NSString *password; //密码

@end

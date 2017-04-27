//
//  YXVerifySMSCodeRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

// 校验验证码
@interface YXVerifySMSCodeRequest : YXPostRequest

@property (nonatomic, strong) NSString *mobile; //手机号
@property (nonatomic, strong) NSString *code;   //验证码
@property (nonatomic, strong) NSString *type;   //0：注册，1：重置密码

@end

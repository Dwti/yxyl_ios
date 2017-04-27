//
//  YXVerifyCodeViewController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/3.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoginBaseViewController.h"

@interface YXVerifyCodeViewController : YXLoginBaseViewController

/**
 *  初始化接口
 *
 *  @param type     获取验证码类型
 *  @param userName 登录页面输入框内容
 *
 *  @return         对象实例
 */
- (instancetype)initWithType:(YXLoginVerifyType)type userName:(NSString *)userName;

@end

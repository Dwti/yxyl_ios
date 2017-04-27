//
//  YXVerifyCodeViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXLoginBaseViewController_Pad.h"

@interface YXVerifyCodeViewController_Pad : YXLoginBaseViewController_Pad

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

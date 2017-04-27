//
//  BindPhoneViewController.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/29/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//
#import "YXLoginBaseViewController.h"

//获取验证码类型
typedef NS_ENUM(NSInteger, BindMobileType) {
    BindMobileTypeVerify,   // 验证手机号
    BindMobileTypeBind,     // 绑定手机
    BindMobileTypeRebind    // 重新绑定
};

@interface BindPhoneViewController : YXLoginBaseViewController
- (instancetype)initWithType:(BindMobileType)type;
@end

//
//  YXEditProfileViewController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/3.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXLoginBaseViewController.h"

@interface YXEditProfileViewController : YXLoginBaseViewController

@property (nonatomic, assign) BOOL isThirdLogin;
@property (nonatomic, strong) NSDictionary *thirdLoginParams; //第三方登录时传参
@property (nonatomic, strong) NSString *mobile;

- (void)setMobile:(NSString *)mobile password:(NSString *)password;

@end

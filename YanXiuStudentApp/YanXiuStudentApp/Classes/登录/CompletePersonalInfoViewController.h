//
//  CompletePersonalInfoViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ScrollBaseViewController.h"

@interface CompletePersonalInfoViewController : ScrollBaseViewController
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, assign) BOOL isThirdLogin;
@property (nonatomic, strong) NSDictionary *thirdLoginParams; //第三方登录时传参
@end

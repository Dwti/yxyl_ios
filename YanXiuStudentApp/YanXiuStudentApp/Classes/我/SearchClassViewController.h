//
//  SearchClassViewController.h
//  YanXiuStudentApp
//
//  Created by FanYu on 11/1/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXMineBaseViewController.h"

@interface SearchClassViewController : YXMineBaseViewController

@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, strong) NSDictionary *thirdLoginParams; //第三方登录时传参
@property (nonatomic, assign) BOOL isThirdLogin;

@end

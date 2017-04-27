//
//  JoinClassViewController.h
//  YanXiuStudentApp
//
//  Created by FanYu on 11/1/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXMineBaseViewController.h"
#import "YXSearchClassRequest.h"
#import "YXClassInfoMock.h"


@interface JoinClassViewController : YXMineBaseViewController

@property (nonatomic, assign) BOOL isThirdLogin;
@property (nonatomic, strong) NSDictionary *thirdLoginParams; //第三方登录时传参
@property (nonatomic, strong) YXSearchClassItem_Data *rawData;
@property (nonatomic, assign) YXClassActionType actionType;

@end

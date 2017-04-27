//
//  YXLoginRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXLoginRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXUserModel, Optional> *data;

@end

//登录
@interface YXLoginRequest : YXPostRequest

@property (nonatomic, strong) NSString *mobile;   //手机号
@property (nonatomic, strong) NSString *password; //密码
@property (nonatomic, strong) NSString *deviceId; //设备id

@end

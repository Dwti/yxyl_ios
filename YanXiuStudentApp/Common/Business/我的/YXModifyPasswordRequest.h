//
//  YXModifyPasswordRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/17.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXUserModel.h"

@interface YXModifyPasswordItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXUserPassport, Optional> *data;

@end

// 修改密码
@interface YXModifyPasswordRequest : YXGetRequest

@property (nonatomic, strong) NSString<Optional> *loginName;    //三方账号
@property (nonatomic, strong) NSString<Optional> *mobile;    //手机号
@property (nonatomic, strong) NSString *oldPass;   //旧密码
@property (nonatomic, strong) NSString *myNewPass; //新密码

@end

//
//  RegisterAccountRequest.h
//  YanXiuStudentApp
//
//  Created by FanYu on 11/5/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface RegisterAccountRequest : YXPostRequest

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *type;     //0：注册，1：重置密码

@end

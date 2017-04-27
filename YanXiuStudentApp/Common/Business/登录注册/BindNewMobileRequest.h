//
//  BindNewMobileRequest.h
//  YanXiuStudentApp
//
//  Created by FanYu on 1/4/2017.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface BindNewMobileRequest : YXPostRequest
@property (nonatomic, strong) NSString *mobile; //手机号
@property (nonatomic, strong) NSString *code;   //验证码
@end

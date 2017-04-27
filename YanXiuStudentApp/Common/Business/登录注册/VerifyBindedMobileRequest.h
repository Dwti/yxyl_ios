//
//  VerifyBindedMobileRequest.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 4/5/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface VerifyBindedMobileRequest : YXPostRequest
@property (nonatomic, strong) NSString *mobile; //手机号
@property (nonatomic, strong) NSString *code;   //验证码
@end

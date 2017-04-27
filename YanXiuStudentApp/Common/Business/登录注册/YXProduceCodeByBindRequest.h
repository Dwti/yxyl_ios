//
//  YXProduceCodeByBindRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 17/04/2017.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXProduceCodeByBindRequest : YXPostRequest

@property (nonatomic, strong) NSString *mobile; //手机号
@property (nonatomic, strong) NSString *type;   //0：注册，1：重置密码

@end

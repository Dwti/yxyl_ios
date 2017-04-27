//
//  AccountRegisterModel.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/23.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountRegisterModel : NSObject

@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *type;     //0：注册，1：重置密码

@end

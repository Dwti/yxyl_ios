//
//  RegisterByUserInfoRequest.h
//  YanXiuStudentApp
//
//  Created by FanYu on 11/5/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface RegisterByUserInfoRequest : YXPostRequest
@property (nonatomic, copy) NSString *mobile;   //手机号
@property (nonatomic, copy) NSString<Optional> *realname;   //真实姓名
@property (nonatomic, copy) NSString<Optional> *provinceid; //省ID
@property (nonatomic, copy) NSString<Optional> *cityid;     //市ID
@property (nonatomic, copy) NSString<Optional> *areaid;     //区县ID
@property (nonatomic, copy) NSString<Optional> *stageid;    //学段ID
@property (nonatomic, copy) NSString<Optional> *schoolName; //学校名称
@property (nonatomic, copy) NSString<Optional> *schoolid;   //学校ID（可为空，与学校名称填一个即可）
@property (nonatomic, copy) NSString<Optional> *head;       //头像（可以为空）
@property (nonatomic, copy) NSString *deviceId;             //设备id
@property (nonatomic, copy) NSString *validKey;

@end

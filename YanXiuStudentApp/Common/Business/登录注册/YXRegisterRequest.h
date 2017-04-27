//
//  YXRegisterRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXRegisterRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXUserModel, Optional> *data;

@end

//注册
@interface YXRegisterRequest : YXPostRequest

@property (nonatomic, strong) NSString *mobile;   //手机号
@property (nonatomic, strong) NSString *password; //密码
@property (nonatomic, strong) NSString<Optional> *realname;  //真实姓名
@property (nonatomic, strong) NSString<Optional> *nickname;  //昵称
@property (nonatomic, strong) NSString<Optional> *provinceid;//省ID
@property (nonatomic, strong) NSString<Optional> *cityid;    //市ID
@property (nonatomic, strong) NSString<Optional> *areaid;    //区县ID
@property (nonatomic, strong) NSString<Optional> *stageid;   //学段ID
@property (nonatomic, strong) NSString<Optional> *schoolName;//学校名称
@property (nonatomic, strong) NSString<Optional> *schoolid;  //学校ID（可为空，与学校名称填一个即可）
@property (nonatomic, strong) NSString<Optional> *head; //头像（可以为空）
@property (nonatomic, strong) NSString *deviceId; //设备id

@end

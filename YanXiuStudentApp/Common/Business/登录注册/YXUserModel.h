//
//  YXUserModel.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/16.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "JSONModel.h"


@protocol YXUserPassport <NSObject>

@end

//帐号信息
@interface YXUserPassport : JSONModel

@property (nonatomic, copy) NSString<Optional> *token;
@property (nonatomic, copy) NSString<Optional> *uid;
@property (nonatomic, copy) NSString<Optional> *mobile;
@property (nonatomic, copy) NSString<Optional> *password;
@property (nonatomic, copy) NSString<Optional> *pid;
@property (nonatomic, copy) NSString<Optional> *loginName;
@property (nonatomic, copy) NSString<Optional> *type;   //0: 账号/手机号， 1: weixin/qq
@end

// 用户信息
@interface YXUserModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *uid;         //用户id
@property (nonatomic, copy) NSString<Optional> *mobile;      //手机号
@property (nonatomic, copy) NSString<Optional> *realname;    //真实姓名
@property (nonatomic, copy) NSString<Optional> *nickname;    //用户昵称
@property (nonatomic, copy) NSString<Optional> *sex;         //性别（0：未知，1：女，2：男）
@property (nonatomic, copy) NSString<Optional> *head;        //头像链接地址
@property (nonatomic, copy) NSString<Optional> *provinceName;//省份
@property (nonatomic, copy) NSString<Optional> *provinceid;  //省份id
@property (nonatomic, copy) NSString<Optional> *cityName;    //市
@property (nonatomic, copy) NSString<Optional> *cityid;      //市id
@property (nonatomic, copy) NSString<Optional> *areaName;    //区县
@property (nonatomic, copy) NSString<Optional> *areaid;      //区县id
@property (nonatomic, copy) NSString<Optional> *schoolName;  //学校
@property (nonatomic, copy) NSString<Optional> *schoolid;    //学校id
@property (nonatomic, copy) NSString<Optional> *stageName;   //学段
@property (nonatomic, copy) NSString<Optional> *stageid;     //学段id
@property (nonatomic, copy) NSString<Optional> *status;      //状态
@property (nonatomic, copy) NSString<Optional> *createtime;  //创建帐号时间
@property (nonatomic, copy) YXUserPassport<Optional> *passport;

@property (nonatomic, strong) NSString<Optional> *isThirdLogin; //是否为第三方登录
@property (nonatomic, copy) NSString<Optional> *isRegisterByJoinClass;
@property (nonatomic, copy) NSString<Optional> *soundSwitchState;//声音是否开启

@end

@protocol YXUserModel <NSObject>

@end

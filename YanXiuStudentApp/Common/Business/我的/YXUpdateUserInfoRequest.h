//
//  YXUpdateUserInfoRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

// 修改用户信息通用接口
@interface YXUpdateUserInfoRequest : YXGetRequest

@property (nonatomic, strong) NSString<Optional> *realname;   //真实姓名
@property (nonatomic, strong) NSString<Optional> *nickname;   //昵称
@property (nonatomic, strong) NSString<Optional> *sex;        //性别
@property (nonatomic, strong) NSString<Optional> *provinceid; //省份id
@property (nonatomic, strong) NSString<Optional> *cityid;     //市id
@property (nonatomic, strong) NSString<Optional> *areaid;     //区县id
@property (nonatomic, strong) NSString<Optional> *schoolName; //学校名
@property (nonatomic, strong) NSString<Optional> *schoolid;   //学校id（学校ID或Name至少填写一个）
@property (nonatomic, strong) NSString<Optional> *stageid;    //学段id

@end


//
//  ThirdRegisterByJoinClassRequest.h
//  YanXiuStudentApp
//
//  Created by FanYu on 11/5/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#include "YXGetRequest.h"

@interface ThirdRegisterRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXUserModel, Optional> *data;

@end


@interface ThirdRegisterByJoinClassRequest : YXGetRequest

@property (nonatomic, copy) NSString *openid;               //用户第三方平台唯一id
@property (nonatomic, copy) NSString *pltform;              //qq/weixin
@property (nonatomic, copy) NSString *deviceId;             //设备id
@property (nonatomic, copy) NSString *unionId;              //微信识别唯一id
@property (nonatomic, copy) NSString<Optional> *nickName;   //昵称
@property (nonatomic, copy) NSString<Optional> *sex;        //0未知，1 女生， 2男生；性别
@property (nonatomic, copy) NSString<Optional> *headimg;    //头像

@property (nonatomic, copy) NSString<Optional> *realname;   //真实姓名
@property (nonatomic, copy) NSString<Optional> *provinceid; //省ID
@property (nonatomic, copy) NSString<Optional> *cityid;     //市ID
@property (nonatomic, copy) NSString<Optional> *areaid;     //区县ID
@property (nonatomic, copy) NSString<Optional> *stageid;    //学段ID
@property (nonatomic, copy) NSString<Optional> *schoolname; //学校名称
@property (nonatomic, copy) NSString<Optional> *schoolid;   //学校ID（可为空，与学校名称填一个即可）
@property (nonatomic, copy) NSString<Optional> *classId;    //班级ID

@end

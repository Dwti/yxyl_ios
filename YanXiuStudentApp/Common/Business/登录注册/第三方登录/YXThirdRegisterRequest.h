//
//  YXThirdRegisterRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/9/24.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXThirdRegisterRequestItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXUserModel, Optional> *data;

@end

@interface YXThirdRegisterRequest : YXPostRequest

@property (nonatomic, strong) NSString *openid;   //用户第三方平台唯一id
@property (nonatomic, strong) NSString *pltform;  //qq/weixin
@property (nonatomic, strong) NSString *deviceId; //设备id
@property (nonatomic, strong) NSString *unionId; //微信识别唯一id
@property (nonatomic, strong) NSString<Optional> *nickName;  //昵称
@property (nonatomic, strong) NSString<Optional> *sex;       //0未知，1 女生， 2男生；性别
@property (nonatomic, strong) NSString<Optional> *headimg;   //头像

@property (nonatomic, strong) NSString<Optional> *realname;  //真实姓名
@property (nonatomic, strong) NSString<Optional> *provinceid;//省ID
@property (nonatomic, strong) NSString<Optional> *cityid;    //市ID
@property (nonatomic, strong) NSString<Optional> *areaid;    //区县ID
@property (nonatomic, strong) NSString<Optional> *stageid;   //学段ID
@property (nonatomic, strong) NSString<Optional> *schoolname;//学校名称
@property (nonatomic, strong) NSString<Optional> *schoolid;  //学校ID（可为空，与学校名称填一个即可）

@end

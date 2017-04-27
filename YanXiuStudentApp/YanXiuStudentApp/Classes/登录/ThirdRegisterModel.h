//
//  ThirdRegisterModel.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/23.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdRegisterModel : NSObject

@property (nonatomic, strong) NSString *openid;   //用户第三方平台唯一id
@property (nonatomic, strong) NSString *pltform;  //qq/weixin
@property (nonatomic, strong) NSString *sex;       //0未知，1 女生， 2男生；性别
@property (nonatomic, strong) NSString *headimg;   //头像
@property (nonatomic, strong) NSString *unionId; //微信识别唯一id
@property (nonatomic, strong) NSString *realname;  //真实姓名
@property (nonatomic, strong) NSString *provinceid;//省ID
@property (nonatomic, strong) NSString *cityid;    //市ID
@property (nonatomic, strong) NSString *areaid;    //区县ID
@property (nonatomic, strong) NSString *stageid;   //学段ID
@property (nonatomic, strong) NSString *schoolname;//学校名称
@property (nonatomic, strong) NSString *schoolid;  //学校ID（可为空，与学校名称填一个即可）
@property (nonatomic, strong) NSString *deviceId; //设备id
@property (nonatomic, strong) NSString *nickName;  //昵称


@end

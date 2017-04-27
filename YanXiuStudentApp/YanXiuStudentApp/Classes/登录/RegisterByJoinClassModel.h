//
//  RegisterByJoinClassModel.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/23.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterByJoinClassModel : NSObject

@property (nonatomic, copy) NSString *mobile;   //手机号
@property (nonatomic, copy) NSString *realname;   //真实姓名
@property (nonatomic, copy) NSString *provinceid; //省ID
@property (nonatomic, copy) NSString *cityid;     //市ID
@property (nonatomic, copy) NSString *areaid;     //区县ID
@property (nonatomic, copy) NSString *stageid;    //学段ID
@property (nonatomic, copy) NSString *schoolName; //学校名称
@property (nonatomic, copy) NSString *schoolid;   //学校ID
@property (nonatomic, copy) NSString *head;       //头像
@property (nonatomic, copy) NSString *deviceId;             //设备id
@property (nonatomic, copy) NSString *classId;
@property (nonatomic, copy) NSString *validKey;

@end

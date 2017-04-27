//
//  YXJoinClassRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

extern NSString *const YXJoinClassSuccessNotification;

// 申请加入班级
@interface YXJoinClassRequest : YXGetRequest

@property (nonatomic, strong) NSString *classId;   //班级ID
@property (nonatomic, strong) NSString *validMsg;  //验证信息
@property (nonatomic, strong) NSString *needCheck; //是否需要审核

@end

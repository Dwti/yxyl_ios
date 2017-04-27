//
//  YXExitClassRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

extern NSString *const YXExitClassSuccessNotification;

// 退出班级
@interface YXExitClassRequest : YXGetRequest

@property (nonatomic, strong) NSString *classId; //班级ID

@end

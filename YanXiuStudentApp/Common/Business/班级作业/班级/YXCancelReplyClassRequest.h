//
//  YXCancelReplyClassRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/9/25.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

extern NSString *const YXCancelReplyClassSuccessNotification;

// 取消申请
@interface YXCancelReplyClassRequest : YXGetRequest

@property (nonatomic, strong) NSString *classId; //班级ID

@end

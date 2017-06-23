//
//  YXQAErrorReportRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/8/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface YXQAErrorReportRequest : YXGetRequest

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *quesId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *type;
@end

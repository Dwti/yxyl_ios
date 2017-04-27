//
//  YXClassInfoMock.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXClassInfoMock.h"

@implementation YXClassInfoMock

+ (YXClassInfoMock *)mockItemFromRealData:(YXSearchClassItem_Data *)data
{
    YXClassInfoMock *mock = [[YXClassInfoMock alloc] init];
    mock.rawData = data;
    mock.iconUrl = [[NSBundle mainBundle] URLForResource:@"班级信息-头像" withExtension:@"png"];
    mock.name = data.name;
    mock.gid = data.gid;
//    mock.subject = data.subjectname;
    mock.teacher = data.adminName;
    mock.headcount = data.stdnum;
    
    return mock;
}

@end

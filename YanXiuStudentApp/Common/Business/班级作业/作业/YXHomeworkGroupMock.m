//
//  YXHomeworkGroupMock.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkGroupMock.h"

@implementation YXHomeworkGroupMock

+ (YXHomeworkGroupMock *)mockWithRealItem:(YXHomeworkListGroupsItem_Data *)data
{
    YXHomeworkGroupMock *mock = [[YXHomeworkGroupMock alloc] init];
    mock.rawData = data;
    
    YXSubjectType type = data.subjectid ? [data.subjectid integerValue]:YXSubjectTypeChinese;
    mock.imageName = [YXSubjectImageHelper homeworkImageNameWithType:type];
    mock.name = data.name;
    if ([data.status integerValue] == 0) {
        if (data.paper.name) {
            mock.homeworkInfo = data.paper.name;
        }
        if ([data.paper.paperStatus.status integerValue] == 1) {
            mock.state = HomeworkGroupState_Ongoing;
        }
        if ([data.paper.paperStatus.status integerValue] == 2) {
            mock.state = HomeworkGroupState_Finished;
        }
    }
    if ([data.status integerValue] == 1) {
        mock.homeworkInfo = @"审核中，暂无法进入班级";
        mock.state = HomeworkGroupState_Verifying;
    }
    if ([data.status integerValue] == 2) {
        mock.homeworkInfo = @"未审核通过";
        mock.state = HomeworkGroupState_Denied;
    }
    
    return mock;
}

@end

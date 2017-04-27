//
//  YXHomeworkMock.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXHomeworkMock.h"

@implementation YXHomeworkMock

+ (YXHomeworkMock *)_mockItemFromRealItem:(YXHomework *)data
{
    YXHomeworkMock *mock = [[YXHomeworkMock alloc] init];
    mock.rawData = data;
    
    mock.name = data.name;
    mock.total = [data.quesnum integerValue];
    mock.bDead = [data.isEnd boolValue];
    mock.deadlineString = [data.overTime stringByAppendingString:@"截止"];
    
    //0 待完成 1 未完成  2 已完成
    if ([data.paperStatus.status intValue] == 0) {
        mock.stateString = YXHomeWorkStatusPartFinish;
    }
    if ([data.paperStatus.status intValue] == 1) {
        mock.stateString = YXHomeWorkStatusNeverFinish;
    }
    if ([data.paperStatus.status intValue] == 2) {
        mock.stateString = YXHomeWorkStatusAllFinish;
    }
    
    if ([data hasTeacherComments]) {
        mock.teacher = data.paperStatus.teacherName;
        mock.comment = data.paperStatus.teachercomments;
    }
    
    return mock;
}

@end

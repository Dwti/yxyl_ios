//
//  YXHomeworkMock.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXHomeworkListRequest.h"

static NSString *YXHomeWorkStatusPartFinish  = @"完成题量";
static NSString *YXHomeWorkStatusNeverFinish = @"未提交作业";
static NSString *YXHomeWorkStatusAllFinish   = @"恭喜你，全部完成^ ^";

@interface YXHomeworkMock : NSObject
@property (nonatomic, copy) NSString *stateString;
@property (nonatomic, assign) BOOL bDead;
@property (nonatomic, copy) NSString *deadlineString;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, copy) NSString *teacher;
@property (nonatomic, copy) NSString *comment;

@property (nonatomic, strong) YXHomework *rawData;

+ (YXHomeworkMock *)_mockItemFromRealItem:(YXHomework *)data;

@end

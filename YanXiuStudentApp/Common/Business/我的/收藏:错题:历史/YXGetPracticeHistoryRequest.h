//
//  YXGetPracticeHistoryRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCommonPageModel.h"

@interface YXGetPracticeHistoryItem_Data : JSONModel

@property (nonatomic, copy) NSString<Optional> *paperId;     //练习Id
@property (nonatomic, copy) NSString<Optional> *name;        //练习名称
@property (nonatomic, copy) NSString<Optional> *stageId;
@property (nonatomic, copy) NSString<Optional> *subjectId;
@property (nonatomic, copy) NSString<Optional> *beditionId;
@property (nonatomic, copy) NSString<Optional> *volume;
@property (nonatomic, copy) NSString<Optional> *chapterId;   //所属章Id
@property (nonatomic, copy) NSString<Optional> *buildTime;
@property (nonatomic, copy) NSString<Optional> *questionNum;
@property (nonatomic, copy) NSString<Optional> *status;      //1：未完成，2：已完成
@property (nonatomic, copy) NSString<Optional> *correctNum;  //正确题数

- (BOOL)isFinished;

@end

@protocol YXGetPracticeHistoryItem_Data <NSObject> @end

@interface YXGetPracticeHistoryItem : HttpBaseRequestItem

@property (nonatomic, copy) YXCommonPageModel<Optional> *page;
@property (nonatomic, copy) NSArray<YXGetPracticeHistoryItem_Data, Optional> *data;

@end

// 获取练习历史
@interface YXGetPracticeHistoryRequest : YXGetRequest

@property (nonatomic, strong) NSString *stageId;    //学段Id
@property (nonatomic, strong) NSString *subjectId;  //科目Id
@property (nonatomic, strong) NSString *beditionId; //教材版本Id
@property (nonatomic, strong) NSString *volume;     //年级Id
@property (nonatomic, strong) NSString *nextPage;   //请求页
@property (nonatomic, strong) NSString *pageSize;   //一页大小

@end

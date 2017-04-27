//
//  YXHomeworkListGroupsRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/15.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCommonPageModel.h"
#import "YXHomework.h"

@protocol YXHomeworkListGroupsItem_Data @end

@interface YXHomeworkListGroupsItem_Data : JSONModel
@property (nonatomic, copy) NSString<Optional> *groupId;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *subjectid; //学科id
@property (nonatomic, copy) NSString<Optional> *subScore;
@property (nonatomic, copy) NSString<Optional> *waitFinishNum;

@property (nonatomic, copy) YXHomework<Optional> *paper;
@property (nonatomic, copy) NSString<Optional> *status;

@end

@interface YXHomeworkListGroupsItem_Property : JSONModel
@property (nonatomic, copy) NSString<Optional> *totalUnfinish;
@property (nonatomic, copy) NSString<Optional> *classId;   //班级id
@property (nonatomic, copy) NSString<Optional> *className; //班级名称

@end

/*
 * 没有加入任何班级 返回code=71
 * 加入班级正在审核中 返回code=72
 * 正常列表 返回code=0
 */
@interface YXHomeworkListGroupsItem : HttpBaseRequestItem
@property (nonatomic, strong) YXCommonPageModel<Optional> *page;
@property (nonatomic, strong) YXHomeworkListGroupsItem_Property<Optional> *property;
@property (nonatomic, strong) NSArray<YXHomeworkListGroupsItem_Data, Optional> *data;
@end

// 列出班级学科
@interface YXHomeworkListGroupsRequest : YXGetRequest

@property (nonatomic, strong) NSString *page;     //当前页码
@property (nonatomic, strong) NSString *pageSize; //每页记录条数

@end

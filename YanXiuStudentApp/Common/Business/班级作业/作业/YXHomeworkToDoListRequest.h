//
//  YXHomeworkToDoListRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/10.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCommonPageModel.h"
#import "YXHomework.h"

@interface YXHomeworkToDoListItem : HttpBaseRequestItem

@property (nonatomic, copy) YXCommonPageModel<Optional> *page;
@property (nonatomic, copy) NSArray<YXHomework, Optional> *data;

@end

// 待完成作业列表
@interface YXHomeworkToDoListRequest : YXGetRequest

@property (nonatomic, strong) NSString *page;     //当前页码
@property (nonatomic, strong) NSString *pageSize; //每页记录条数

@end

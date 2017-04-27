//
//  YXClassHomeworkFetcher.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"

typedef NS_ENUM(NSUInteger, HomeworkFetchState) {
    HomeworkFetch_NeedAddClass,
    HomeworkFetch_NeedVerify,
    HomeworkFetch_Error,
    HomeworkFetch_Success
};

@class YXHomeworkListGroupsItem;
@interface YXClassHomeworkFetcher : PagedListFetcherBase

@property (nonatomic, assign) NSInteger totalUnfinish;
@property (nonatomic, copy) void (^classJoinBlock)(YXHomeworkListGroupsItem *item, HomeworkFetchState state);

@end

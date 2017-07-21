//
//  YXExerciseHistoryListFetcher.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/19.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"

@class GetPracticeEditionRequestItem_subject;

@interface YXExerciseHistoryListFetcher : PagedListFetcherBase

@property (nonatomic, strong) GetPracticeEditionRequestItem_subject *subject;
@property (nonatomic, copy) NSString *volumeID;
@property (nonatomic, copy) void (^emptyBlock)(NSError *error);
@property (nonatomic, copy) void (^errorBlock)(NSError *error);

@end

@interface YXExerciseHistoryByKnowListFetcher : YXExerciseHistoryListFetcher

@end

//
//  YXHomeworkToDoFetcher.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface YXHomeworkToDoFetcher : PagedListFetcherBase

@property (nonatomic, copy) void (^emptyBlock)(void);

@end

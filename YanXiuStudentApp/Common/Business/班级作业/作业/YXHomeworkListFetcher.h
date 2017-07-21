//
//  YXHomeworkListFetcher.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface YXHomeworkListFetcher : PagedListFetcherBase

@property (nonatomic, copy) NSString *gid;
@property (nonatomic, strong) void (^emptyBlock)();

@end

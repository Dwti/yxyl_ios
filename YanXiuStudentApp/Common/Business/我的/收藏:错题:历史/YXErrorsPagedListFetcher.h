//
//  YXErrorsPagedListFetcher.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/17.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface YXErrorsPagedListFetcher : PagedListFetcherBase

@property (nonatomic, copy) NSString *subjectID;
@property (nonatomic, copy) NSString *stageID;


@end

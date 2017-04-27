//
//  YXHomeworkViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/10/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "YXHomeworkListGroupsRequest.h"

@interface YXHomeworkViewController : PagedListViewControllerBase
@property (nonatomic, strong) YXHomeworkListGroupsItem_Data *groupInfoData;
- (instancetype)initWithFetcher:(PagedListFetcherBase *)fetcher;
@end

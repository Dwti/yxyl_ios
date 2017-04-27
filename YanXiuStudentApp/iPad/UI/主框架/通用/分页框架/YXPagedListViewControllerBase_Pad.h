//
//  YXPagedListViewControllerBase_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"
#import "PagedListFetcherBase.h"
#import "YXCommonErrorView.h"

@interface YXPagedListViewControllerBase_Pad : YXBaseViewController_Pad
{
    PagedListFetcherBase *_dataFetcher;
    long _total;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL bIsGroupedTableViewStyle;    // currently trick
@property (nonatomic, strong) NSMutableArray *dataArray;        // the model
@property (nonatomic, assign) BOOL bNeedHeader;
@property (nonatomic, assign) BOOL bNeedFooter;

@property (nonatomic, strong) PagedListFetcherBase *dataFetcher;
@property (nonatomic, strong) YXCommonErrorView *errorView;

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic, assign) long total;

- (void)firstPageFetch;
- (void)morePageFetch;
- (void)stopAnimation;
- (void)setPulldownViewHidden:(BOOL)hidden;
- (void)setPullupViewHidden:(BOOL)hidden;
- (void)checkHasMore;

@property (nonatomic, assign) int emptyViewTopInset;

- (void)firstPageRequestBack;

@end

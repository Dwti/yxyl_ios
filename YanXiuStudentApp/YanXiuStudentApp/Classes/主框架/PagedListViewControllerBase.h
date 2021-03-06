//
//  PagedListViewControllerBase.h
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "BaseViewController.h"
#import "PagedListFetcherBase.h"
#import "YXCommonErrorView.h"
#import "MJRefresh.h"
#import "EmptyView.h"

@interface PagedListViewControllerBase : BaseViewController<UITableViewDataSource, UITableViewDelegate>
{
    PagedListFetcherBase *_dataFetcher;
    long _total;
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL bIsGroupedTableViewStyle;    // currently trick
@property (nonatomic, strong) NSMutableArray *dataArray;        // the model
@property (nonatomic, assign) BOOL bNeedHeader;
@property (nonatomic, assign) BOOL bNeedFooter;
@property (nonatomic, assign) BOOL isShowTip;//内容穷尽处的提示是否显示 默认不显示,需要显示时设为YES即可
@property (nonatomic, strong) PagedListFetcherBase *dataFetcher;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) EmptyView *emptyView;
@property (nonatomic, assign) long total;
@property (nonatomic, weak) id<PageListRequestDelegate> requestDelegate;
@property (nonatomic, assign) int emptyViewTopInset;

- (void)firstPageFetch;
- (void)morePageFetch;
- (void)stopAnimation;
- (void)setPulldownViewHidden:(BOOL)hidden;
- (void)setPullupViewHidden:(BOOL)hidden;
- (void)checkHasMore;
- (void)firstPageRequestBack;

@end

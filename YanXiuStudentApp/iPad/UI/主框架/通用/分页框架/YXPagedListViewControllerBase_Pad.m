//
//  YXPagedListViewControllerBase_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/2/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXPagedListViewControllerBase_Pad.h"
#import "MJRefresh.h"

@interface YXPagedListViewControllerBase_Pad () <UITableViewDataSource, UITableViewDelegate> {
    
    MJRefreshFooterView *_footer;
    MJRefreshHeaderView *_header;
}

@end

@implementation YXPagedListViewControllerBase_Pad

- (id)init {
    if (self = [super init]) {
        _bNeedHeader = YES;
        _bNeedFooter = YES;
        _bIsGroupedTableViewStyle = NO;
    }
    return self;
}

- (void)dealloc
{
    DDLogWarn(@"PagedListViewController Dealloc");
    [_header free];
    [_footer free];
    [self.dataFetcher stop];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    if (self.bIsGroupedTableViewStyle) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    } else {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    }
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self yx_startLoading];
        [self firstPageFetch];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    [self hideErrorView];
    
    if (self.bNeedFooter) {
        _footer = [MJRefreshFooterView footer];
        _footer.scrollView = self.tableView;
        _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            @strongify(self); if (!self) return;
            [self morePageFetch];
        };
        _footer.alpha = 0;
    }
    
    if (self.bNeedHeader) {
        _header = [MJRefreshHeaderView header];
        _header.scrollView = self.tableView;
        _header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
            @strongify(self); if (!self) return;
            [self firstPageFetch];
        };
    }
    
    self.dataArray = [NSMutableArray array];
    [self.dataArray addObjectsFromArray:[self.dataFetcher cachedItemArray]];
    _total = (int)[self.dataArray count];
    [self yx_startLoading];
    [self firstPageFetch];
//    [self->_footer setAutoresizesSubviews:NO];
//    [RACObserve(self->_footer, alpha) subscribeNext:^(id x) {
//        @strongify(self);
//        for (UIView *view in self->_footer.subviews) {
//            view.alpha = 1;
//            view.hidden = NO;
//            NSLog(@"%@ hidden = %d, alpha = %f", view.class, view.hidden, view.alpha);
//        }
//    }];
//    for (UIView *view in self->_footer.subviews) {
//        [RACObserve(view, alpha) map:^id(id value) {
//            return @1;
//        }];
//        [RACObserve(view, hidden) map:^id(id value) {
//            return @NO;
//        }];
//    }

}

- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    
    [self.dataFetcher stop];
    
    // 1, load cache
    //    [self.dataArray removeAllObjects];
    //    [self.dataArray addObjectsFromArray:[self.dataFetcher cachedItemArray]];
    //    _total = (int)[self.dataArray count];
    
    // 2, fetch
    self.dataFetcher.pageindex = 0;
    if (!self.dataFetcher.pagesize) {
        self.dataFetcher.pagesize = 20;
    }
    
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self firstPageRequestBack];
            @strongify(self); if (!self) return;
            [self yx_stopLoading];
            [self stopAnimation];
            if (error) {
                if (isEmpty(self.dataArray)) {  // no cache 强提示, 加载失败界面
                    self->_total = 0;
                    self.errorView.errorCode = [NSString stringWithFormat:@"%@", @(error.code)];
                    [self showErroView];
                } else {
                    [self yx_showToast:error.localizedDescription];
                }
                [self checkHasMore];
                return;
            }
            
            // 隐藏失败界面
            [self hideErrorView];
            
            [self->_header setLastUpdateTime:[NSDate date]];
            self->_total = total;
            [self.dataArray removeAllObjects];
            
            if (isEmpty(retItemArray)) {
                self.emptyView.hidden = NO;
            } else {
                self.emptyView.hidden = YES;
                [self.dataArray addObjectsFromArray:retItemArray];
                [self checkHasMore];
                [self.dataFetcher saveToCache];
            }
            [self.tableView reloadData];
        });
    }];
}

- (void)firstPageRequestBack
{
    
}

- (void)stopAnimation
{
    [self->_header endRefreshing];
}

- (void)setPulldownViewHidden:(BOOL)hidden
{
    _header.alpha = hidden ? 0:1;
}

- (void)setPullupViewHidden:(BOOL)hidden
{
//    if (!hidden) {
//        @weakify(self);
//        [_footer free];
//        _footer = [MJRefreshFooterView footer];
//        _footer.scrollView = self.tableView;
//        _footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
//            @strongify(self); if (!self) return;
//            [self morePageFetch];
//        };
//        _footer.alpha = 0;
//    }
    _footer.alpha = hidden ? 0:1;
}

- (void)morePageFetch {
    [self.dataFetcher stop];
    self.dataFetcher.pageindex++;
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self); if (!self) return;
            [self->_footer endRefreshing];
            if (error) {
                self.dataFetcher.pageindex--;
                [self yx_showToast:error.localizedDescription];
                return;
            }
            
            [self.dataArray addObjectsFromArray:retItemArray];
            [self.tableView reloadData];
            [self checkHasMore];
        });
    }];
}

- (void)showErroView {
    self.errorView.hidden = NO;
    [self.view bringSubviewToFront:self.errorView];
}

- (void)hideErrorView {
    self.errorView.hidden = YES;
}

- (void)checkHasMore {
    // there is a bug is MJRefresh, so we use alpha instead of hidden
    [self setPullupViewHidden:[self.dataArray count] >= _total];
}
#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

@end

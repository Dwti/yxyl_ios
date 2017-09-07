//
//  PagedListViewControllerBase.m
//  YanXiuApp
//
//  Created by Lei Cai on 5/21/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "PagedListViewControllerBase.h"
#import "YXClassHomeworkFetcher.h"
#import "GlobalUtils.h"

static const CGFloat kTipViewHeight = 20.f;

@interface PagedListViewControllerBase ()
@property(nonatomic, strong) UIView *tipView;
@property(nonatomic, assign) CGFloat lastContentOffset;
@end

@implementation PagedListViewControllerBase

- (id)init {
    self = [super init];
    if (self) {
        _bNeedHeader = YES;
        _bNeedFooter = YES;
        _bIsGroupedTableViewStyle = NO;
        _isShowTip = NO;
    }
    return self;
}

- (void)dealloc
{
    DDLogWarn(@"PagedListViewController Dealloc");
    [_header free];
    [_footer free];
    [self.dataFetcher stop];
    if (self.isShowTip) {
        [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    }
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
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    if (!self.emptyView) {
        self.emptyView = [[EmptyView alloc]init];
    }
    self.emptyView.hidden = YES;
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(@0);
    }];
    
    if (!self.errorView) {
        self.errorView = [[YXCommonErrorView alloc]init];
    }
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self.view nyx_startLoading];
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
    self.requestDelegate = self.dataFetcher;
    [self.view nyx_startLoading];
    [self firstPageFetch];
    if (self.isShowTip) {
        [self setupTipView];
    }
}

- (void)firstPageFetch {
    if (!self.dataFetcher) {
        return;
    }
    [self.dataFetcher stop];

    SAFE_CALL(self.requestDelegate, requestWillRefresh);
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        [self firstPageRequestBack];
        SAFE_CALL_OneParam(self.requestDelegate, requestEndRefreshWithError, error);
        [self.view nyx_stopLoading];
        [self stopAnimation];
        if (error) {
            if (isEmpty(self.dataArray)) {  // no cache 强提示, 加载失败界面
                self->_total = 0;
                [self showErroView];
            } else {
                [self.view nyx_showToast:error.localizedDescription];
            }
            [self checkHasMore];
            return;
        }
        
        // 隐藏失败界面
        [self hideErrorView];
        
        [self->_header setLastUpdateTime:[NSDate date]];
        self.total = total;
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
    //self.dataFetcher.pageindex++;
    SAFE_CALL(self.requestDelegate, requestWillFetchMore);
    @weakify(self);
    [self.dataFetcher startWithBlock:^(int total, NSArray *retItemArray, NSError *error) {
        @strongify(self); if (!self) return;
        SAFE_CALL_OneParam(self.requestDelegate, requestEndFetchMoreWithError, error);
        @weakify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            @strongify(self); if (!self) return;
            [self->_footer endRefreshing];
            if (error) {
                self.dataFetcher.pageindex--;
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            
            [self.dataArray addObjectsFromArray:retItemArray];
            [self.tableView reloadData];
            [self checkHasMore];
        });
    }];
}

- (void)showErroView {
//    [self.view addSubview:self.errorView];
//    [self.errorView mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(@0);
//    }];
    self.errorView.hidden = NO;
    [self.view bringSubviewToFront:self.errorView];
}

- (void)hideErrorView {
//    [self.errorView removeFromSuperview];
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


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 100;
//}

- (void)setupTipView {
    self.tipView = [[UIView alloc]init];
    self.tipView.backgroundColor = [UIColor clearColor];
    [self.tableView addSubview:self.tipView];
    [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    self.tipView.frame = CGRectMake(0, self.tableView.contentSize.height + self.tableView.y, self.tableView.width, kTipViewHeight);
    UILabel *textLabel = [[UILabel alloc]initWithFrame:self.tipView.bounds];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"这回真没了";
    textLabel.font = [UIFont systemFontOfSize:14.f];
    textLabel.textColor = [UIColor colorWithHexString:@"a8a7a8"];
    
    [self.tipView addSubview:textLabel];
    self.tipView.hidden = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.tableView.contentSize.height + self.tableView.y < SCREEN_HEIGHT) {
        self.tipView.hidden = YES;
        return;
    }
    self.tipView.frame = CGRectMake(0, self.tableView.contentSize.height + self.tableView.y, self.tableView.width, kTipViewHeight);
    if (self.tableView.contentInset.bottom > 0) {
        return;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTipViewHeight + 10, 0);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y < self.lastContentOffset - 5*kTipViewHeight)
    {
        if (self.tipView.hidden == YES) {
            return;
        }
        self.tipView.hidden = YES;
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
    
    CGFloat height = scrollView.frame.size.height;
    CGFloat contentYoffset = scrollView.contentOffset.y;
    CGFloat distanceFromBottom = scrollView.contentSize.height - contentYoffset;
    if (distanceFromBottom < height && ([self.dataArray count] >= _total)) {
        if (self.tipView.hidden == NO) {
            return;
        }
        self.tipView.hidden = NO;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kTipViewHeight + 10, 0);
    }
}

@end

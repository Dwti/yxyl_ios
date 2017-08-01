//
//  TreeBaseViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "TreeBaseViewController.h"
#import "YXCommonErrorView.h"
#import "TreeNodeProtocol.h"
#import "GlobalUtils.h"

@interface TreeBaseViewController ()
@property (nonatomic, strong) YXCommonErrorView *errorView;

@end

@implementation TreeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor clearColor];
    [self setupUI];
    [self fetchTreeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.treeView = [[RATreeView alloc] initWithFrame:CGRectZero style:RATreeViewStylePlain];
    self.treeView.delegate = self;
    self.treeView.dataSource = self;
    self.treeView.showsVerticalScrollIndicator = NO;
    self.treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
    self.treeView.estimatedRowHeight = 50;
    self.treeView.rowsExpandingAnimation = RATreeViewRowAnimationFade;
    self.treeView.rowsCollapsingAnimation = RATreeViewRowAnimationFade;
    self.treeView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.treeView];
    [self.treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.treeView.frame.size.width, 10)];
    headerView.backgroundColor = [UIColor clearColor];
    self.treeView.treeHeaderView = headerView;
    
    self.errorView = [[YXCommonErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self fetchTreeData];
    }];
    
    self.emptyView = [[EmptyView alloc]init];
    self.emptyView.title = @"暂无题目";
}

- (void)fetchTreeData {
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.dataFetcher fetchTreeDataWithCompleteBlock:^(NSArray *treeNodes, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        
        self.treeNodes = treeNodes;
        [self.treeView reloadData];
        
        if (error.code == 3) {
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        
        if (error) {
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        
        [self.emptyView removeFromSuperview];
        [self.errorView removeFromSuperview];
    }];
}

#pragma mark - RATreeViewDataSource
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item {
    if (!item) {
        return self.treeNodes.count;
    }
    id<TreeNodeProtocol> node = item;
    return [node subNodes].count;
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item {
    if (!item) {
        return self.treeNodes[index];
    }
    id<TreeNodeProtocol> node = item;
    return [node subNodes][index];
}

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item {
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}

#pragma mark - RATreeViewDelegate
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item {
    return NO;
}

- (BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item {
    return NO;
}


@end

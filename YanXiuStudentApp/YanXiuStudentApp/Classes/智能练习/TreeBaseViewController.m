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
@property (nonatomic, strong) NSArray *treeNodes;
@end

@implementation TreeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    self.treeView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.treeView];
    [self.treeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.treeView.frame.size.width, 23)];
    headerView.backgroundColor = [UIColor clearColor];
    self.treeView.treeHeaderView = headerView;
    
    self.errorView = [[YXCommonErrorView alloc] init];
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self fetchTreeData];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    
    
    YXTipsView *emptyView = [[YXTipsView alloc] init];
    [self.view addSubview:emptyView];
    [emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    emptyView.title = @"O(∩_∩)O";
    emptyView.text = @"暂无题目";
    [emptyView hide:NO];
    self.emptyView = emptyView;
    
}

- (void)fetchTreeData {
    WEAK_SELF
    [self yx_startLoading];
    [self.dataFetcher fetchTreeDataWithCompleteBlock:^(NSArray *treeNodes, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        
        self.treeNodes = treeNodes;
        [self removeLevelFourBelow];
        [self.treeView reloadData];
        
        if (error.code == 3) {
            [self.emptyView show:NO];
            return;
        }
        
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
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

- (void)removeNode:(id<TreeNodeProtocol>)node forLevel:(int)level {
    if (level == 0) {
        node.subNodes = nil;
    }
    
    for (id<TreeNodeProtocol> subnode in node.subNodes) {
        [self removeNode:subnode forLevel:level-1];
    }
}

- (void)removeLevelFourBelow {
    for (id<TreeNodeProtocol> node in self.treeNodes) {
        [self removeNode:node forLevel:3];
    }
}
@end

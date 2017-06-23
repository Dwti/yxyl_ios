//
//  QAClozeContainerView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/25/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAClozeContainerView.h"
#import "QAClozeStemCell.h"

@interface QAClozeContainerView () <
UITableViewDataSource,
UITableViewDelegate,
YXHtmlCellHeightDelegate
>

@property (nonatomic, assign) CGFloat yueCellHeight;
@property (nonatomic, strong) QAQuestion *qaData;
@property (nonatomic, strong) UIView *lineView;

@end


@implementation QAClozeContainerView

- (instancetype)initWithData:(QAQuestion *)data {
    if (self = [super init]) {
        self.qaData = data;
        
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.yueCellHeight = [QAClozeStemCell heightForString:self.qaData.stem];
 
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[QAClozeStemCell class] forCellReuseIdentifier:@"QAClozeStemCell"];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    UIView *bottomLineView = [[UIView alloc]init];
    bottomLineView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    self.lineView = bottomLineView;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self.tableView addGestureRecognizer:tap];
}

- (void)tapAction {
    if ([self.delegate respondsToSelector:@selector(stemClicked)]) {
        [self.delegate stemClicked];
    }
}

- (void)setIsAnalysis:(BOOL)isAnalysis {
    _isAnalysis = isAnalysis;
    if (isAnalysis) {
        [self.lineView removeFromSuperview];
    }
}

- (void)scrollCurrentBlankToVisible {
    UIView *view = [self.clozeCell currentBlankView];
    [self.tableView scrollRectToVisible:[view convertRect:view.bounds toView:self.tableView] animated:YES];
}

#pragma mark - QAComplexTopContainerViewDelegate
- (CGFloat)initialHeight {
    return self.yueCellHeight;
}

#pragma mark- UITableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.yueCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.yueCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAClozeStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAClozeStemCell"];
    cell.delegate = self;
    cell.selectItemDelegate = self.delegate;
    cell.question = self.qaData;
    cell.currentIndex = self.clozeCell.currentIndex;
    self.clozeCell = cell;
    
    return cell;
}

- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    if (!ip) {
        return;
    }
    
    CGFloat h = self.yueCellHeight;
    CGFloat nh = ceilf(height);
    if (h != nh) {
        self.yueCellHeight = nh;
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView layoutIfNeeded];
    }
}

@end

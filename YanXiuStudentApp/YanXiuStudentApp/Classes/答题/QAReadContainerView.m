//
//  QAReadContainerView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/25/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAReadContainerView.h"
#import "QAReadStemCell.h"

@interface QAReadContainerView () <
UITableViewDataSource,
UITableViewDelegate,
YXHtmlCellHeightDelegate
>

@property (nonatomic, assign) CGFloat yueCellHeight;
@property (nonatomic, strong) QAQuestion *qaData;
@property (nonatomic, strong) YXNoFloatingHeaderFooterTableView *tableView;

@end


@implementation QAReadContainerView

- (instancetype)initWithData:(QAQuestion *)data {
    if (self = [super init]) {
        self.qaData = data;
        
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (void)setupUI {
    self.yueCellHeight = [QAReadStemCell heightForString:self.qaData.stem isSubQuestion:NO];
    
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.userInteractionEnabled = YES;
    [self.tableView registerClass:[QAReadStemCell class] forCellReuseIdentifier:@"QAReadStemCell"];
}

- (void)setupLayout {    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
#pragma mark - QAComplexTopContainerViewDelegate
- (CGFloat)initialHeight {
    return self.yueCellHeight;
}

#pragma mark - tableView datasource
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
    QAReadStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAReadStemCell"];
    cell.delegate = self;
    [cell updateWithString:self.qaData.stem isSubQuestion:NO];
    return cell;
}

#pragma mark - height delegate
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

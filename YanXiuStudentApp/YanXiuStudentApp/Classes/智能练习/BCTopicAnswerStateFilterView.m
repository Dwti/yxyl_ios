//
//  BCTopicAnswerStateFilterView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BCTopicAnswerStateFilterView.h"
#import "BCTopicAnswerStateFilterCell.h"

@interface BCTopicAnswerStateFilterView ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *dataArray;
@property(nonatomic, copy) AnswerStateFilterCompletedBlock block;
@end

@implementation BCTopicAnswerStateFilterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDataArray];
        [self setupUI];
    }
    return self;
}

- (void)setupDataArray {
    self.dataArray = @[
                       @"全部",
                       @"已作答",
                       @"未作答"
                       ];
}
- (void)setupUI {
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.f;
    [self.tableView registerClass:[BCTopicAnswerStateFilterCell class] forCellReuseIdentifier:@"BCTopicAnswerStateFilterCell"];
    [self addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCTopicAnswerStateFilterCell *cell = [[BCTopicAnswerStateFilterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.title = self.dataArray[indexPath.row];
    if (self.selectedRow == indexPath.row) {
        cell.selected = YES;
    }else {
        cell.selected = NO;
    }
    if (indexPath.row == self.dataArray.count - 1) {
        cell.shouldShowLine = NO;
    }else {
        cell.shouldShowLine = YES;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    BLOCK_EXEC(self.block,self.dataArray[indexPath.row],indexPath.row);
}

- (void)setAnswerStateFilterCompletedBlock:(AnswerStateFilterCompletedBlock)block {
    self.block = block;
}
@end

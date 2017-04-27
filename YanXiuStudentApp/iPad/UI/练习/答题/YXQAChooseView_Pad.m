//
//  YXQAChooseView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAChooseView_Pad.h"
#import "YXQATitleCell_Pad.h"
#import "YXQAQuestionCell_Pad.h"
#import "YXQAChooseAnswerCell_Pad.h"
#import "YXNoFloatingHeaderFooterTableView.h"

@implementation YXQAChooseView_Pad{
    BOOL _bLayoutDone;
    NSDate *beginDate;
}

- (void)startLoading {
    if (!isEmpty(self.data.myAnswers)) {
        _myAnswerArray = [NSMutableArray arrayWithArray:self.data.myAnswers];
    } else {
        _myAnswerArray = [NSMutableArray array];
        for (int i = 0; i < [self.data.options count]; i++) {
            [_myAnswerArray addObject:@NO];
        }
    }
    beginDate = [NSDate date];
}

- (void)cancelLoading {
    if (isEmpty(_myAnswerArray)) {
        return;
    }
    
    self.data.myAnswers = [NSMutableArray arrayWithArray:_myAnswerArray];
    if (beginDate) {
        NSTimeInterval time = [[NSDate date]timeIntervalSinceDate:beginDate];
        self.data.answerDuration += time;
        beginDate = nil;
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (!_bLayoutDone) {
        [self _setupUI];
    }
    _bLayoutDone = YES;
    
    [self layoutIfNeeded];
}

- (void)_setupUI {
    _heightArray = [NSMutableArray array];
    if (self.bShowTitleState) {
        YXQATitleCell_Pad *titleCell = [[YXQATitleCell_Pad alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        titleCell.item = self.data;
        titleCell.title = self.title;
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:titleCell];
        [titleCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.mas_equalTo(35);
        }];
    }
    
    [_heightArray addObject:@([YXQAQuestionCell_Pad heightForString:self.data.stem dashHidden:NO])];
    for (int i = 0; i < [self.data.options count]; i++) {
        [_heightArray addObject:@([YXQAChooseAnswerCell_Pad heightForString:self.data.options[i]])];
    }
    
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    [self addSubview:self.tableView];
    CGFloat top = self.bShowTitleState? 35:0;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(top, 0, 0, 0));
    }];

    [self.tableView registerClass:[YXQAQuestionCell_Pad class] forCellReuseIdentifier:@"YXQAQuestionCell_Pad"];
    [self.tableView registerClass:[YXQAChooseAnswerCell_Pad class] forCellReuseIdentifier:@"YXQAChooseAnswerCell_Pad"];
}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_heightArray[indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_heightArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YXQAQuestionCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAQuestionCell_Pad"];
        cell.delegate = self;
        cell.item = self.data;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    NSInteger answerIndex = indexPath.row - 1;
    
    YXQAChooseAnswerCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAChooseAnswerCell_Pad"];
    cell.delegate = self;
    cell.bChoosed = NO;
    if ([_myAnswerArray[answerIndex] boolValue]) {
        cell.bChoosed = YES;
    }
    [cell updateWithItem:self.data forIndex:answerIndex];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >= 1) {
        [self.tableView reloadData];
    }
}

#pragma mark - height delegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    if (!ip) {
        return;
    }
    
    CGFloat h = [_heightArray[ip.row] floatValue];
    CGFloat nh = ceilf(height);
    if (h != nh) {
        [_heightArray replaceObjectAtIndex:ip.row withObject:@(nh)];
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView layoutIfNeeded];
    }
    
}

@end

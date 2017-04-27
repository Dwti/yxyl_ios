//
//  YXQAYesNoView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAYesNoView_Pad.h"
#import "YXQATitleCell_Pad.h"
#import "YXQAQuestionCell_Pad.h"
#import "YXNoFloatingHeaderFooterTableView.h"

@implementation YXQAYesNoView_Pad{
    BOOL _bLayoutDone;
    NSMutableArray *_myAnswerArray;
    NSDate *beginDate;
}

- (void)startLoading {
    if (!isEmpty(self.data.myAnswers)) {
        _myAnswerArray = [NSMutableArray arrayWithArray:self.data.myAnswers];
    } else {
        _myAnswerArray = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            [_myAnswerArray addObject:@NO];
        }
    }
    
    self.chooseView.myAnswerArray = _myAnswerArray;
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
    
    [_heightArray addObject:@([YXQAQuestionCell_Pad heightForString:self.data.stem dashHidden:YES])];
    
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    [self addSubview:self.tableView];
    CGFloat top = self.bShowTitleState? 35:0;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(top, 0, 76+15, 0));
    }];
    [self.tableView registerClass:[YXQAQuestionCell_Pad class] forCellReuseIdentifier:@"YXQAQuestionCell_Pad"];
    
    YXQAYesNoChooseCell_Pad *chooseView = [[YXQAYesNoChooseCell_Pad alloc] init];
    chooseView.myAnswerArray = _myAnswerArray;
    chooseView.delegate = self.delegate;
    chooseView.item = self.data;
    [self addSubview:chooseView];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(76+15);
    }];
    self.chooseView = chooseView;
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
    YXQAQuestionCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAQuestionCell_Pad"];
    cell.dashLineHidden = YES;
    cell.delegate = self;
    cell.item = self.data;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView layoutIfNeeded];
    }
}



@end

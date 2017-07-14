//
//  QASingleQuestionAnswerBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/11.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASingleQuestionAnswerBaseView.h"
@implementation QASingleQuestionAnswerBaseView
- (void)setupUI {
    [super setupUI];
    self.cellHeightArray = [self heightArrayForCell];
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 45, 0);
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleView.mas_bottom);
        make.left.right.bottom.equalTo(self);
    }];
}
- (NSMutableArray *)heightArrayForCell {
    return [NSMutableArray array];
}
#pragma mark - tableview datasource delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellHeightArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [[UITableViewCell alloc]init];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cellHeightArray[indexPath.row] floatValue];
}
#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (!indexPath) {
        return;
    }
    CGFloat cellHeight = [self.cellHeightArray[indexPath.row] floatValue];
    CGFloat newCellHeight = ceilf(height);
    if (cellHeight < newCellHeight) {
        [self.cellHeightArray replaceObjectAtIndex:indexPath.row withObject:@(newCellHeight)];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
}
@end

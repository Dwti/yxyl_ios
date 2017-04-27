//
//  QAConnectQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAConnectQuestionAnalysisView.h"
#import "YXQAConnectTitleCell.h"
#import "YXConnectContentCell.h"

@interface QAConnectQuestionAnalysisView ()
@property (nonatomic, strong) NSMutableArray *contentGroupArray;
@end
@implementation QAConnectQuestionAnalysisView
- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[YXQAConnectTitleCell class] forCellReuseIdentifier:@"YXQAConnectTitleCell"];
    [self.tableView registerClass:[YXConnectContentCell class] forCellReuseIdentifier:@"YXConnectContentCell"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([YXQAConnectTitleCell heightForString:self.data.stem])];
    [heightArray addObject:@([YXConnectContentCell heightForItem:self.data])];
    return heightArray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YXQAConnectTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAConnectTitleCell"];
        cell.delegate = self;
        cell.title = self.data.stem;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row ==1) {
        YXConnectContentCell *cell = [[YXConnectContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (self.contentGroupArray) {
            cell.groupArray = self.contentGroupArray;
        }
        cell.item = self.data;
        cell.delegate = self;
        self.contentGroupArray = cell.groupArray;
        cell.userInteractionEnabled = NO;
        cell.showAnalysisAnswers = YES;
        return cell;
    }else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end

//
//  QAChooseQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAChooseQuestionView.h"
#import "YXQAQuestionCell2.h"
#import "YXQAChooseAnswerCell2.h"

@implementation QAChooseQuestionView
- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[YXQAQuestionCell2 class] forCellReuseIdentifier:@"YXQAQuestionCell2"];
    [self.tableView registerClass:[YXQAChooseAnswerCell2 class] forCellReuseIdentifier:@"YXQAChooseAnswerCell2"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([YXQAQuestionCell2 heightForString:self.data.stem dashHidden:NO])];
    for (int i = 0; i < self.data.options.count; i++) {
        [heightArray addObject:@([YXQAChooseAnswerCell2 heightForString:self.data.options[i]])];
    }
    return heightArray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YXQAQuestionCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAQuestionCell2"];
        cell.delegate = self;
        cell.item = self.data;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    NSInteger answerIndex = indexPath.row - 1;
    YXQAChooseAnswerCell2 *cell = [[YXQAChooseAnswerCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.delegate = self;
    cell.bChoosed = NO;
    if ([self.data.myAnswers[answerIndex] boolValue]) {
        cell.bChoosed = YES;
    }
    [cell updateWithItem:self.data forIndex:answerIndex];
    return cell;
}
@end

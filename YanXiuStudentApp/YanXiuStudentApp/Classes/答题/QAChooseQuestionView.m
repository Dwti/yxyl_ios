//
//  QAChooseQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAChooseQuestionView.h"
#import "QAQuestionStemCell.h"
#import "QAChooseOptionCell.h"

@implementation QAChooseQuestionView
- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self.tableView registerClass:[QAChooseOptionCell class] forCellReuseIdentifier:@"QAChooseOptionCell"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    for (int i = 0; i < self.data.options.count; i++) {
        [heightArray addObject:@([QAChooseOptionCell heightForString:self.data.options[i]])];
    }
    return heightArray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }
    NSInteger answerIndex = indexPath.row - 1;
    QAChooseOptionCell *cell = [[QAChooseOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.delegate = self;
    cell.isLast = indexPath.row==self.data.options.count;
    cell.choosed = NO;
    if ([self.data.myAnswers[answerIndex] boolValue]) {
        cell.choosed = YES;
    }
    [cell updateWithOption:self.data.options[answerIndex] forIndex:answerIndex];
    return cell;
}
@end

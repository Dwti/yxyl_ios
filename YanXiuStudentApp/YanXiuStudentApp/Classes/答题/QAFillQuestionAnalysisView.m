//
//  QAFillQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAFillQuestionAnalysisView.h"
#import "YXQAQuestionCell2.h"
#import "QAFillQuestionCell.h"

@interface QAFillQuestionAnalysisView ()

@end

@implementation QAFillQuestionAnalysisView

- (void)leaveForeground {
    [self endEditing:YES];
    [super leaveForeground];
}

- (void)setupUI{
    [super setupUI];
    [self.tableView registerClass:[QAFillQuestionCell class] forCellReuseIdentifier:@"QAFillQuestionCell"];
}
- (NSMutableArray *)heightArrayForCell{
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([YXQAQuestionCell2 heightForString:self.data.stem dashHidden:NO])];
    return heightArray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QAFillQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAFillQuestionCell"];
        cell.delegate = self;
        cell.placeHolder = [QAQuestionUtil answerPlaceholderWithQuestion:self.data maxLength:[QAFillQuestionCell maxContentWidth]];
        cell.item = self.data;
        cell.dashLineHidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
        return cell;
    }
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}
@end

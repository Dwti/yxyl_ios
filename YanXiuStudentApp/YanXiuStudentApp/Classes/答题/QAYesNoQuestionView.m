//
//  QAYesNoQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAYesNoQuestionView.h"
#import "YXQAYesNoChooseCell.h"
#import "YXQAQuestionCell2.h"

@interface QAYesNoQuestionView ()
@property (nonatomic, strong) YXQAYesNoChooseCell *chooseView;
@end

@implementation QAYesNoQuestionView
- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[YXQAYesNoChooseCell class] forCellReuseIdentifier:@"YXQAYesNoChooseCell"];
    [self.tableView registerClass:[YXQAQuestionCell2 class] forCellReuseIdentifier:@"YXQAQuestionCell2"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([YXQAQuestionCell2 heightForString:self.data.stem dashHidden:YES])];
    [heightArray addObject:@(76+15)];
    return heightArray;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        YXQAQuestionCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAQuestionCell2"];
        cell.dashLineHidden = YES;
        cell.delegate = self;
        cell.item = self.data;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    YXQAYesNoChooseCell *chooseView = [tableView dequeueReusableCellWithIdentifier:@"YXQAYesNoChooseCell"];
    chooseView.myAnswerArray = self.data.myAnswers;
    chooseView.delegate = self.delegate;
    chooseView.item = self.data;
    self.chooseView = chooseView;
    return chooseView;
}

@end

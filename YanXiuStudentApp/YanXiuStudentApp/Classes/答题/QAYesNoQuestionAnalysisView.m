//
//  QAYesNoQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAYesNoQuestionAnalysisView.h"
#import "YXQAQuestionCell2.h"
#import "YXQAYesNoChooseCell.h"
@interface QAYesNoQuestionAnalysisView ()
@property (nonatomic, strong) YXQAYesNoChooseCell *chooseView;
@end
@implementation QAYesNoQuestionAnalysisView

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[YXQAYesNoChooseCell class] forCellReuseIdentifier:@"YXQAYesNoChooseCell"];
    [self.tableView registerClass:[YXQAQuestionCell2 class] forCellReuseIdentifier:@"YXQAQuestionCell2"];
}
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([YXQAQuestionCell2 heightForString:self.data.stem dashHidden:YES])];
    [heightArray addObject:@(73)];
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
    }if (indexPath.row == 1) {
        YXQAYesNoChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAYesNoChooseCell"];
        cell.userInteractionEnabled = NO;
        [cell resetYesNoState];
        if (!self.analysisDataHidden) {
            [cell updateWithMyAnswer:self.data.myAnswers correctAnswer:self.data.correctAnswers];
        }
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}
@end

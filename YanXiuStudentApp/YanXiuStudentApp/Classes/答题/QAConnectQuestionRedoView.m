//
//  QAConnectQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/18/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QAConnectQuestionRedoView.h"


//@interface QAConnectQuestionRedoView () <YXConnectContentCellDelegate>
//@property (nonatomic, strong) NSMutableArray *contentGroupArray;
//@end
//
@implementation QAConnectQuestionRedoView
//
//- (void)setupUI {
//    [super setupUI];
//    [self.tableView registerClass:[YXQAConnectTitleCell class] forCellReuseIdentifier:@"YXQAConnectTitleCell"];
//    [self.tableView registerClass:[YXConnectContentCell class] forCellReuseIdentifier:@"YXConnectContentCell"];
//}
//
//- (NSMutableArray *)heightArrayForCell {
//    NSMutableArray *heightArray = [NSMutableArray array];
//    [heightArray addObject:@([YXQAConnectTitleCell heightForString:self.data.stem])];
//    [heightArray addObject:@([YXConnectContentCell heightForItem:self.data])];
//    return heightArray;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        YXQAConnectTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAConnectTitleCell"];
//        cell.delegate = self;
//        cell.title = self.data.stem;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }else if (indexPath.row ==1) {
//        YXConnectContentCell *cell = [[YXConnectContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
//        if (self.contentGroupArray) {
//            cell.groupArray = self.contentGroupArray;
//        }
//        cell.item = self.data;
//        cell.delegate = self;
//        cell.redoStatusDelegate = self;
//        self.contentGroupArray = cell.groupArray;
//        
//        if (self.data.redoStatus == QARedoStatus_CanDelete || self.data.redoStatus == QARedoStatus_AlreadyDelete) {
//            cell.userInteractionEnabled = NO;
//            cell.showAnalysisAnswers = YES;
//        }
//        
//        return cell;
//    }else {
//        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    }
//}

//- (void)updateRedoStatus {
//    if ([self.data answerState] == YXAnswerStatePartAnswer) {
//        self.data.redoStatus = QARedoStatus_Init;
//    } else {
//        self.data.redoStatus = QARedoStatus_CanSubmit;
//    }
//}

@end

//
//  QAConnectQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/18/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QAConnectQuestionRedoView.h"
#import "MistakeConnectQuestionView.h"
#import "QAQuestionStemCell.h"
#import "QAConnectAnalysisContentCell.h"

@interface QAConnectQuestionRedoView ()
@property (nonatomic, strong) MistakeConnectQuestionView *questionView;
@property (nonatomic, strong) NSMutableArray *contentGroupArray;

@end

@implementation QAConnectQuestionRedoView

- (void)setupUI {
    [super setupUI];
    self.tableView.hidden = YES;
    self.questionView = [[MistakeConnectQuestionView alloc]init];
    self.questionView.data = self.oriData;
    self.questionView.isSubQuestionView = self.isSubQuestionView;
    WEAK_SELF
    [self.questionView setMistakeConnectQuestionAnswerStateChangeBlock:^(NSUInteger answerState) {
        STRONG_SELF
        if (answerState == YXAnswerStateCorrect || answerState == YXAnswerStateWrong) {
            self.data.redoStatus = QARedoStatus_CanSubmit;
        }else {
            self.data.redoStatus = QARedoStatus_Init;
        }
    }];
    [self addSubview:self.questionView];
    [self.questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    if (self.data.redoStatus == QARedoStatus_CanDelete || self.data.redoStatus == QARedoStatus_AlreadyDelete) {
        self.tableView.hidden = NO;
        self.questionView.hidden = YES;
    }else {
        self.tableView.hidden = YES;
        self.questionView.hidden = NO;
    }
    
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self.tableView registerClass:[QAConnectAnalysisContentCell class] forCellReuseIdentifier:@"QAConnectAnalysisContentCell"];
}

- (void)refreshForRedoStatusChange {
    [super refreshForRedoStatusChange];
    if (self.data.redoStatus == QARedoStatus_CanDelete) {
        self.questionView.hidden = YES;
        self.tableView.hidden = NO;
    }
}

#pragma mark -  QAClassifyManagerDelegate
- (void)updateRedoStatus {
    if ([self.data answerState] == YXAnswerStatePartAnswer) {
        self.data.redoStatus = QARedoStatus_Init;
    } else {
        self.data.redoStatus = QARedoStatus_CanSubmit;
    }
}

#pragma mark - analysis
- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
    [heightArray addObject:@([QAConnectAnalysisContentCell heightForItem:self.data])];
    return heightArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tableView.hidden == YES) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }
    if (indexPath.row == 0) {
        UITableViewCell<QAComplexHeaderCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseID];
        if (!cell) {
            cell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
            cell.cellHeightDelegate = self;
            self.headerCell = cell;
        }
        return cell;
    }else if (indexPath.row == 1) {
        if (self.hideQuestion) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            return cell;
        }
        QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
        cell.bottomLineHidden = YES;
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }else if (indexPath.row == 2) {
        QAConnectAnalysisContentCell *cell = [[QAConnectAnalysisContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (self.contentGroupArray) {
            cell.groupArray = self.contentGroupArray;
        }
        cell.item = self.data;
        self.contentGroupArray = cell.groupArray;
        cell.userInteractionEnabled = NO;
        cell.showAnalysisAnswers = YES;
        WEAK_SELF
        [cell setCellHeightChangeBlock:^(CGFloat height) {
            STRONG_SELF
            CGFloat cellHeight = [QAConnectAnalysisContentCell heightForItem:self.data];
            CGFloat newCellHeight = ceil(height);
            if (cellHeight < newCellHeight) {
                [self.cellHeightArray replaceObjectAtIndex:indexPath.row withObject:@(newCellHeight)];
                [self.tableView beginUpdates];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self.tableView endUpdates];
            }
        }];
        return cell;
        
    }else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end

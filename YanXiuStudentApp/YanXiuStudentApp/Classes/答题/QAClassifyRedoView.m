//
//  QAClassifyRedoView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/18/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QAClassifyRedoView.h"
#import "MistakeClassifyQuestionView.h"
#import "QAClassifyAnswerResultCell.h"
#import "QAQuestionStemCell.h"
#import "QAAnalysisResultCell.h"
#import "QAMistakeAnalysisDataConfig.h"

@interface QAClassifyRedoView ()
@property (nonatomic, strong) MistakeClassifyQuestionView *questionView;
@end

@implementation QAClassifyRedoView

- (void)setupUI {
    [super setupUI];
    self.tableView.hidden = YES;
    self.questionView = [[MistakeClassifyQuestionView alloc]init];
    self.questionView.data = self.data;
    WEAK_SELF
    [self.questionView setMistakeClassifyQuestionAnswerStateChangeBlock:^(NSUInteger answerState) {
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
    [self.tableView registerClass:[QAClassifyAnswerResultCell class] forCellReuseIdentifier:@"QAClassifyAnswerResultCell"];
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
    [heightArray addObject:@([QAClassifyAnswerResultCell heightForQuestion:self.data])];
    return heightArray;
}

#pragma mark- UITableViewDataSource
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
        QAClassifyAnswerResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAClassifyAnswerResultCell"];
        cell.question = self.data;
        cell.delegate = self;
        return cell;
    }else {
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[QAAnalysisResultCell class]]) {
            QAAnalysisResultCell *resultCell = (QAAnalysisResultCell *)cell;
            resultCell.maxImageWidth = 80;
        }
        return cell;
    }
}

@end

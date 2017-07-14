//
//  QAConnectQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAConnectQuestionView.h"
#import "QAQuestionStemCell.h"
#import "QAComplexHeaderCellDelegate.h"
#import "QAComplexHeaderFactory.h"
#import "QAConnectContentCell.h"
#import "QAConnectContentView.h"
#import "QAConnectOptionInfo.h"
#import "QAConnectSelectedView.h"
#import "QAConnectSelectedCell.h"

static const CGFloat kBottomViewHeight = 77.f;

@interface QAConnectQuestionView ()
@property (nonatomic, strong) QAConnectContentView *contentView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) QAConnectSelectedView *selectedView;
@property (nonatomic, strong) AlertView *alertView;
//@property (nonatomic,strong) UITableViewCell<QAComplexHeaderCellDelegate> *headerCell;

@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *allOptionInfoArray;
@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *leftOptionInfoArray;
@property (nonatomic, strong) NSMutableArray<QAConnectOptionInfo *> *rightOptionInfoArray;
@end

@implementation QAConnectQuestionView

- (void)leaveForeground {
    [super leaveForeground];
    SAFE_CALL(self.headerCell, leaveForeground);
}

- (void)setData:(QAQuestion *)data {
    [super setData:data];
    self.allOptionInfoArray = [NSMutableArray array];
    NSInteger index = 0;
    for (NSString *option in self.data.options) {
        QAConnectOptionInfo *info = [[QAConnectOptionInfo alloc]init];
        info.option = option;
        info.index = index;
        QAConnectContentCell *cell = [[QAConnectContentCell alloc]init];
        cell.optionString = option;
        info.size = [cell defaultSize];
        [self.allOptionInfoArray addObject:info];
        index++;
    }
    
    for (QANumberGroupAnswer *groupAnswer in data.myAnswers) {
        [groupAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.boolValue) {
                self.allOptionInfoArray[idx].selected = YES;
            }
        }];
    }
    
    self.leftOptionInfoArray = [NSMutableArray array];
    self.rightOptionInfoArray = [NSMutableArray array];
    NSInteger groupCount = self.allOptionInfoArray.count/2;
    for (int i = 0; i < groupCount; i++) {
        QAConnectOptionInfo *leftInfo = self.allOptionInfoArray[i];
        QAConnectOptionInfo *rightInfo = self.allOptionInfoArray[i + groupCount];
        [self.leftOptionInfoArray addObject:leftInfo];
        [self.rightOptionInfoArray addObject:rightInfo];
    }
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QAQuestionStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
    return heightArray;
}

- (void)setupUI {
    [super setupUI];
    self.tableView.scrollEnabled = NO;
    [self.tableView registerClass:[QAQuestionStemCell class] forCellReuseIdentifier:@"QAQuestionStemCell"];
    [self updateTableViewLayout];
    self.backgroundColor = [UIColor whiteColor];
    
    self.bottomView = [[UIView alloc]init];
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kBottomViewHeight);
    }];
    
    self.contentView = [[QAConnectContentView alloc]init];
    [self.contentView updateWithLeftOptionArray:self.leftOptionInfoArray rightOPtionArray:self.rightOptionInfoArray];
    WEAK_SELF
    [self.contentView setSelectedTwinOptionActionBlock:^(QAConnectOptionInfo *leftOptionInfo, QAConnectOptionInfo *rightOptionInfo) {
        STRONG_SELF
        [self putSelectedOptionsWithLeftOption:leftOptionInfo rightOption:rightOptionInfo];
        
    }];
    [self addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(15.0f);
        make.right.mas_equalTo(-15.0f);
        make.bottom.mas_equalTo(self.bottomView.mas_top).offset(-27.f);
    }];
    
    self.selectedView = [[QAConnectSelectedView alloc]init];
    [self loadSelectedViewData];
    [self.selectedView setFoldActionBlock:^{
        STRONG_SELF
        if (self.selectedView.isFold) {
            [self unfoldSelectedView];
        }else {
            [self foldSelectedView];
        }
    }];
    [self addSubview:self.selectedView];
    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-kBottomViewHeight - 20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(SCREEN_HEIGHT - 15);
    }];
}

- (void)updateTableViewLayout {
    CGFloat tableHeight = 0.f;
    for (NSNumber *num in self.cellHeightArray) {
        tableHeight += num.floatValue;
    }
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(tableHeight);
    }];
}

- (void)putSelectedOptionsWithLeftOption:(QAConnectOptionInfo *)leftInfo rightOption:(QAConnectOptionInfo *)rightInfo {
    leftInfo.selected = YES;
    rightInfo.selected = YES;
    
    YXQAAnswerState fromState = [self.data answerState];
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[leftInfo.index];
    [groupAnswer.answers replaceObjectAtIndex:leftInfo.index withObject:@(YES)];
    [groupAnswer.answers replaceObjectAtIndex:rightInfo.index withObject:@(YES)];
    [self.data saveAnswer];
    
    [self.contentView updateWithLeftOptionArray:self.leftOptionInfoArray rightOPtionArray:self.rightOptionInfoArray];
    
    QAConnectTwinOptionInfo *info = [[QAConnectTwinOptionInfo alloc]init];
    info.leftOptionInfo = leftInfo;
    info.rightOptionInfo = rightInfo;
    info.height = [QAConnectSelectedCell heightForTwinOption:info];
    [self.selectedView.optionInfoArray addObject:info];
    [self.selectedView reloadData];
    
    YXQAAnswerState toState = [self.data answerState];
    if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
        [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
    }
}

- (void)loadSelectedViewData {
    for (QANumberGroupAnswer *groupAnswer in self.data.myAnswers) {
        __block NSMutableArray *answerArray = [NSMutableArray array];
        [groupAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.boolValue) {
                [answerArray addObject:@(idx)];
            }
        }];
        if (answerArray.count == 2) {
            QAConnectTwinOptionInfo *info = [[QAConnectTwinOptionInfo alloc]init];
            info.leftOptionInfo = [self.allOptionInfoArray objectAtIndex:[answerArray.firstObject integerValue]];
            info.rightOptionInfo = [self.allOptionInfoArray objectAtIndex:[answerArray.lastObject integerValue]];
            info.height = [QAConnectSelectedCell heightForTwinOption:info];
            [self.selectedView.optionInfoArray addObject:info];
            [self.selectedView reloadData];
        }
    }
}

- (void)unfoldSelectedView {
    self.selectedView.isFold = NO;
    
    self.alertView = [[AlertView alloc]init];
    self.alertView.maskColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
    self.alertView.hideWhenMaskClicked = NO;
    WEAK_SELF
    [self.alertView setHideBlock:^(AlertView *view){
        STRONG_SELF
        [UIView animateWithDuration:.3 animations:^{
            [self.selectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(0);
                make.top.equalTo(view.mas_bottom).offset(-kBottomViewHeight - 20);
                make.height.mas_equalTo(SCREEN_HEIGHT - 15);
            }];
            [view layoutIfNeeded];
        }completion:^(BOOL finished) {
            [view removeFromSuperview];
            self.selectedView.isFold = YES;
            [self addSubview:self.selectedView];
            [self.selectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom).offset(-kBottomViewHeight - 20);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(SCREEN_HEIGHT - 15);
            }];
        }];
    }];
    [self.selectedView setDeleteActionBlock:^(QAConnectTwinOptionInfo *twinOption) {
        STRONG_SELF
        QAConnectOptionInfo *leftOptionInfo = twinOption.leftOptionInfo;
        QAConnectOptionInfo *rightOptionInfo = twinOption.rightOptionInfo;
        [self removeSelectedOptionsWithLeftOption:leftOptionInfo rightOption:rightOptionInfo];
        [self.selectedView.optionInfoArray removeObject:twinOption];
        [self.selectedView reloadData];
    }];
    [self.selectedView setDeleteAllActionBlock:^(NSMutableArray<QAConnectTwinOptionInfo *> *optionInfoArray) {
        STRONG_SELF
        for (QAConnectTwinOptionInfo *twinOption in optionInfoArray) {
            QAConnectOptionInfo *leftOptionInfo = twinOption.leftOptionInfo;
            leftOptionInfo.selected = NO;
            QAConnectOptionInfo *rightOptionInfo = twinOption.rightOptionInfo;
            rightOptionInfo.selected = NO;
            [self removeSelectedOptionsWithLeftOption:leftOptionInfo rightOption:rightOptionInfo];
        }
        [self.selectedView.optionInfoArray removeAllObjects];
        [self.selectedView reloadData];
    }];
    self.alertView.contentView = self.selectedView;
    [self.alertView showInView:self.window withLayout:^(AlertView *view) {
        [self.selectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(view);
            make.top.equalTo(view.mas_bottom).offset(- kBottomViewHeight - 20);
            make.height.mas_equalTo(SCREEN_HEIGHT - 15);
        }];
        [view layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [self.selectedView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(15.f);
                make.left.right.bottom.mas_equalTo(0);
            }];
            [view layoutIfNeeded];
        }];
    }];
}

- (void)foldSelectedView {
    [self.alertView hide];
}

- (void)removeSelectedOptionsWithLeftOption:(QAConnectOptionInfo *)leftInfo rightOption:(QAConnectOptionInfo *)rightInfo {
    YXQAAnswerState fromState = [self.data answerState];
    QANumberGroupAnswer *groupAnswer = self.data.myAnswers[leftInfo.index];
    [groupAnswer.answers replaceObjectAtIndex:leftInfo.index withObject:@(NO)];
    [groupAnswer.answers replaceObjectAtIndex:rightInfo.index withObject:@(NO)];
    [self.data saveAnswer];
    
    [self.contentView updateWithLeftOptionArray:self.leftOptionInfoArray rightOPtionArray:self.rightOptionInfoArray];
    
    YXQAAnswerState toState = [self.data answerState];
    if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
        [self.answerStateChangeDelegate question:self.data didChangeAnswerStateFrom:fromState to:toState];
    }
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell<QAComplexHeaderCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseID];
        if (!cell) {
            cell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
            cell.cellHeightDelegate = self;
            self.headerCell = cell;
        }
        return cell;
    }
    if (self.hideQuestion) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }
    QAQuestionStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAQuestionStemCell"];
    cell.delegate = self;
    cell.bottomLineHidden = YES;
    [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
    return cell;
}

#pragma mark - YXHtmlCellHeightDelegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    [super tableViewCell:cell updateWithHeight:height];
    [self updateTableViewLayout];
}
@end

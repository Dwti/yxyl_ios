//
//  QASubjectiveQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/11/30.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveQuestionRedoView.h"
#import "QAQuestionUtil.h"
#import "QASubjectiveStemCell.h"
#import "QASubjectivePhotoCell.h"
#import "MistakeSubjectiveQuestionView.h"

@interface QASubjectiveQuestionRedoView ()
@property (nonatomic, strong) MistakeSubjectiveQuestionView *questionView;
@end

@implementation QASubjectiveQuestionRedoView

- (void)setupUI {
    [super setupUI];
    self.questionView = [[MistakeSubjectiveQuestionView alloc]init];
    self.questionView.data = self.oriData;
    self.questionView.isSubQuestionView = self.isSubQuestionView;
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

    [self.tableView registerClass:[QASubjectiveStemCell class] forCellReuseIdentifier:@"QASubjectiveStemCell"];
    [self.tableView registerClass:[QASubjectivePhotoCell class] forCellReuseIdentifier:@"QASubjectivePhotoCell"];
}

- (void)refreshForRedoStatusChange {
    [super refreshForRedoStatusChange];
    if (self.data.redoStatus == QARedoStatus_CanDelete) {
        self.questionView.hidden = YES;
        self.tableView.hidden = NO;
    }
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    if (self.hideQuestion) {
        [heightArray addObject:@(0.0001)];
    }else {
        [heightArray addObject:@([QASubjectiveStemCell heightForString:self.data.stem isSubQuestion:self.isSubQuestionView])];
    }
    [heightArray addObject:@(100)];
    return heightArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
        QASubjectiveStemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QASubjectiveStemCell"];
        cell.delegate = self;
        [cell updateWithString:self.data.stem isSubQuestion:self.isSubQuestionView];
        return cell;
    }else if (indexPath.row == 2){
        QASubjectivePhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QASubjectivePhotoCell"];
        [cell updateWithPhotos:self.data.myAnswers editable:NO];
        return cell;
    }else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

@end

//
//  QASubjectiveQuestionAnalysisView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/24.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveQuestionAnalysisView.h"
#import "QASubjectiveStemCell.h"
#import "QASubjectivePhotoCell.h"
#import "QAComplexHeaderFactory.h"

@interface QASubjectiveQuestionAnalysisView ()
@end

@implementation QASubjectiveQuestionAnalysisView

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QASubjectiveStemCell class] forCellReuseIdentifier:@"QASubjectiveStemCell"];
    [self.tableView registerClass:[QASubjectivePhotoCell class] forCellReuseIdentifier:@"QASubjectivePhotoCell"];
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
    }else if (indexPath.row == 2) {
        QASubjectivePhotoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"QASubjectivePhotoCell"];
        [cell updateWithPhotos:self.data.myAnswers editable:NO];
        return cell;
    }else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)leaveForeground {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeaveForegroundNotification" object:nil];
}
@end

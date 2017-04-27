//
//  QAYesNoQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/17/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QAYesNoQuestionRedoView.h"
#import "YXQAYesNoChooseCell.h"
#import "YXQAQuestionCell2.h"

@interface QAYesNoQuestionRedoView () <YXQAYesNoChooseCellDelegate>
@property (nonatomic, strong) YXQAYesNoChooseCell *chooseView;
@end

@implementation QAYesNoQuestionRedoView

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
    }else if (indexPath.row == 1) {
        self.chooseView = [tableView dequeueReusableCellWithIdentifier:@"YXQAYesNoChooseCell"];
        self.chooseView.myAnswerArray = self.data.myAnswers;
        self.chooseView.delegate = self.delegate;
        self.chooseView.item = self.data;
        self.chooseView.redoStatusDelegate = self;
        
        QARedoStatus status = self.data.redoStatus;
        if (status==QARedoStatus_CanDelete || status==QARedoStatus_AlreadyDelete) {
            [self.chooseView updateWithMyAnswer:self.data.myAnswers correctAnswer:self.data.correctAnswers];
            self.chooseView.userInteractionEnabled = NO;
        }
        return self.chooseView;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    
}

- (void)updateRedoStatus {
    if ([self.data answerState] == YXAnswerStateNotAnswer) {
        self.data.redoStatus = QARedoStatus_Init;
    } else {
        self.data.redoStatus = QARedoStatus_CanSubmit;
    }
}

@end

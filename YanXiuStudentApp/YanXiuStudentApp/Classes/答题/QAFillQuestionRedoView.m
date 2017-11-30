//
//  QAFillQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/18/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QAFillQuestionRedoView.h"
#import "QAFillBlankCell.h"

@interface QAFillQuestionRedoView ()
@property (nonatomic, strong) QAFillBlankCell *blankCell;
@end

@implementation QAFillQuestionRedoView

#pragma mark-
- (void)dealloc {
    [self unRegisterKeyboardNotifications];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self registerKeyboardNotifications];
    }
    return self;
}

- (void)leaveForeground {
    [self endEditing:YES];
    [self.blankCell resetCurrentBlank];
    [super leaveForeground];
}

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAFillBlankCell class] forCellReuseIdentifier:@"QAFillBlankCell"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    UITableViewCell<QAComplexHeaderCellDelegate> *headerCell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
    [heightArray addObject:@([headerCell heightForQuestion:self.oriData])];
    [heightArray addObject:@([QAFillBlankCell heightForString:self.data.stem])];
    return heightArray;
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell<QAComplexHeaderCellDelegate> *cell = [tableView dequeueReusableCellWithIdentifier:kHeaderCellReuseID];
        if (!cell) {
            cell = [QAComplexHeaderFactory headerCellClassForQuestion:self.oriData];
            cell.cellHeightDelegate = self;
            self.headerCell = cell;
        }
        return cell;
    }else if (indexPath.row == 1){
        QAFillBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAFillBlankCell"];
        cell.delegate = self;
        if (self.data.redoStatus == QARedoStatus_CanDelete) {
            cell.isAnalysis = YES;
            cell.userInteractionEnabled = NO;
        }else {
            cell.isAnalysis = NO;
            cell.userInteractionEnabled = YES;
        }
        cell.question = self.data;
        cell.answerStateChangeDelegate = self.answerStateChangeDelegate;
        self.blankCell = cell;
        WEAK_SELF
        [cell setMistakeFillBlankQuestionAnswerStateChangeBlock:^(NSUInteger answerState) {
            STRONG_SELF
            if (answerState == YXAnswerStateCorrect || answerState == YXAnswerStateWrong) {
                self.data.redoStatus = QARedoStatus_CanSubmit;
            }else {
                self.data.redoStatus = QARedoStatus_Init;
            }
        }];
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Keyboard Observer
- (void)registerKeyboardNotifications {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrameNoti:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)unRegisterKeyboardNotifications {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyboardChangeFrameNoti:(NSNotification *)noti {
    NSDictionary *dic = noti.userInfo;
    NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
    CGFloat bottom = [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y;
    bottom = MAX(bottom, 45);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
    
    
    if ([UIScreen mainScreen].bounds.size.height > keyboardFrame.origin.y) {
        UIView *v = [self.blankCell currentBlankView];
        CGRect rect = [v convertRect:v.bounds toView:self.window];
        CGFloat visibleHeight = keyboardFrame.origin.y;
        if (rect.origin.y+rect.size.height > visibleHeight) {
            CGPoint offset = self.tableView.contentOffset;
            offset.y = offset.y+rect.origin.y+rect.size.height-visibleHeight;
            self.tableView.contentOffset = offset;
        }
    }
}

#pragma mark - QAFillQuestionCellDelegate
- (void)updateRedoStatus {
    if (self.data.redoStatus == QARedoStatus_CanDelete || self.data.redoStatus == QARedoStatus_AlreadyDelete) {
        return;
    }
    
    if ([self.data answerState] == YXAnswerStatePartAnswer || [self.data answerState] == YXAnswerStateNotAnswer) {
        self.data.redoStatus = QARedoStatus_Init;
    } else {
        self.data.redoStatus = QARedoStatus_CanSubmit;
    }
}

@end

//
//  QAFillQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAFillQuestionView.h"
#import "QAFillBlankCell.h"

@interface QAFillQuestionView ()
@property (nonatomic, strong) QAFillBlankCell *blankCell;
@end

@implementation QAFillQuestionView

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
    }
    QAFillBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAFillBlankCell"];
    cell.delegate = self;
    cell.question = self.data;
    cell.answerStateChangeDelegate = self.answerStateChangeDelegate;
    self.blankCell = cell;
    return cell;
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

@end

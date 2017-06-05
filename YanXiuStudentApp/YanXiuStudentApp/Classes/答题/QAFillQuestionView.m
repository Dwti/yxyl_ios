//
//  QAFillQuestionView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/10/20.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAFillQuestionView.h"
#import "YXQAQuestionCell2.h"
#import "QAFillQuestionCell.h"
#import "QAFillBlankCell.h"

@interface QAFillQuestionView ()
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
    [super leaveForeground];
}

- (void)setData:(QAQuestion *)data {
    [super setData:data];
    [self.tableView reloadData];
}

- (void)setupUI {
    [super setupUI];
    [self.tableView registerClass:[QAFillBlankCell class] forCellReuseIdentifier:@"QAFillBlankCell"];
}

- (NSMutableArray *)heightArrayForCell {
    NSMutableArray *heightArray = [NSMutableArray array];
    [heightArray addObject:@([QAFillBlankCell heightForString:self.data.stem])];
    return heightArray;
}

#pragma mark - tableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QAFillBlankCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAFillBlankCell"];
    cell.delegate = self;
    cell.question = self.data;
    cell.answerStateChangeDelegate = self.answerStateChangeDelegate;
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
}

@end

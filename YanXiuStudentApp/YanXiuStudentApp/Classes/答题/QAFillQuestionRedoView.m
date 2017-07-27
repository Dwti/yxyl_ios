//
//  QAFillQuestionRedoView.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/18/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "QAFillQuestionRedoView.h"

@interface QAFillQuestionRedoView ()

@end

@implementation QAFillQuestionRedoView

//- (void)dealloc {
//    [self unRegisterKeyboardNotifications];
//}
//
//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
//        [self registerKeyboardNotifications];
//    }
//    return self;
//}
//
//- (void)leaveForeground {
//    [self endEditing:YES];
//    [super leaveForeground];
//}
//
//- (void)setData:(QAQuestion *)data {
//    [super setData:data];
//    [self.tableView reloadData];
//}
//
//- (void)setupUI {
//    [super setupUI];
//    [self.tableView registerClass:[QAFillQuestionCell class] forCellReuseIdentifier:@"QAFillQuestionCell"];
//}
//
//- (NSMutableArray *)heightArrayForCell {
//    NSMutableArray *heightArray = [NSMutableArray array];
//    [heightArray addObject:@([YXQAQuestionCell2 heightForString:self.data.stem dashHidden:NO])];
//    return heightArray;
//}
//
//#pragma mark - tableViewDataSource
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        QAFillQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QAFillQuestionCell"];
//        cell.delegate = self;
//        cell.placeHolder = [QAQuestionUtil answerPlaceholderWithQuestion:self.data maxLength:[QAFillQuestionCell maxContentWidth]];
//        cell.item = self.data;
//        cell.dashLineHidden = YES;
//        cell.redoStatusDelegate = self;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        QARedoStatus status = self.data.redoStatus;
//        if (status==QARedoStatus_CanDelete || status==QARedoStatus_AlreadyDelete) {
//            cell.userInteractionEnabled = NO;
//        }
//        
//        return cell;
//    }
//    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
//}
//
//#pragma mark - QAFillQuestionCellDelegate
//- (void)updateRedoStatus {
//    if (self.data.redoStatus == QARedoStatus_CanDelete || self.data.redoStatus == QARedoStatus_AlreadyDelete) {
//        return;
//    }
//    
//    if ([self.data answerState] == YXAnswerStatePartAnswer || [self.data answerState] == YXAnswerStateNotAnswer) {
//        self.data.redoStatus = QARedoStatus_Init;
//    } else {
//        self.data.redoStatus = QARedoStatus_CanSubmit;
//    }
//}
//
//#pragma mark - Keyboard Observer
//- (void)registerKeyboardNotifications {
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrameNoti:) name:UIKeyboardWillChangeFrameNotification object:nil];
//}
//
//- (void)unRegisterKeyboardNotifications {
//    [[NSNotificationCenter defaultCenter]removeObserver:self];
//}
//
//- (void)keyboardChangeFrameNoti:(NSNotification *)noti {
//    NSDictionary *dic = noti.userInfo;
//    NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
//    CGFloat bottom = [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y-50;
//    bottom = MAX(bottom, 20);
//    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, bottom, 0);
//}

@end

//
//  YXQAFillBlankView_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAFillBlankView_Pad.h"
#import "YXQATitleCell_Pad.h"
#import "YXQAFillBlankCell_Pad.h"
#import "YXNoFloatingHeaderFooterTableView.h"

@interface YXQAFillBlankView_Pad()<UITextFieldDelegate>
@property (nonatomic, strong) UITextView *textView;
@end

@implementation YXQAFillBlankView_Pad{
    BOOL _bLayoutDone;
    
    NSString *_adjustText;
    NSMutableArray *_myAnswerArray;
    NSDate *beginDate;
}

- (void)dealloc{
    [self unRegisterKeyboardNotifications];
}
- (void)startLoading {
    if (!isEmpty(self.data.myAnswers)) {
        _myAnswerArray = [NSMutableArray arrayWithArray:self.data.myAnswers];
    } else {
        _myAnswerArray = [NSMutableArray array];
        for (int i = 0; i < [_textFieldArray count]; i++) {
            [_myAnswerArray addObject:[NSNull null]];
        }
    }
    
    for (int i = 0; i < [_textFieldArray count]; i++) {
        id text = _myAnswerArray[i];
        UITextField *tf = _textFieldArray[i];
        if (!(text == [NSNull null])) {
            tf.text = text;
        }
    }
    [self registerKeyboardNotifications];
    beginDate = [NSDate date];
}

- (void)cancelLoading {
    if (isEmpty(_myAnswerArray)) {
        return;
    }
    
    for (int i = 0; i < [_textFieldArray count]; i++) {
        UITextField *tf = _textFieldArray[i];
        [tf resignFirstResponder];
        if (!isEmpty(tf.text)||[tf.text isEqualToString:@""]) {
            [_myAnswerArray replaceObjectAtIndex:i withObject:tf.text];
        }
    }
    self.data.myAnswers = [NSMutableArray arrayWithArray:_myAnswerArray];
    [self unRegisterKeyboardNotifications];
    if (beginDate) {
        NSTimeInterval time = [[NSDate date]timeIntervalSinceDate:beginDate];
        self.data.answerDuration += time;
        beginDate = nil;
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_bLayoutDone) {
        [self _setupUI];
    }
    _bLayoutDone = YES;
    
    [self layoutIfNeeded];
}

- (void)_setupUI {
    _heightArray = [NSMutableArray array];
    if (self.bShowTitleState) {
        YXQATitleCell_Pad *titleCell = [[YXQATitleCell_Pad alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        titleCell.item = self.data;
        titleCell.title = self.title;
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:titleCell];
        [titleCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.height.height.mas_equalTo(35);
        }];
    }
    
    _textFieldArray = [NSMutableArray array];
    self.textView = [[UITextView alloc] init];
    self.textView.userInteractionEnabled = NO;
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = [UIColor colorWithHexString:@"323232"];
    self.textView.text = [self adjustText];
    CGFloat width = self.frame.size.width-80-17-17-40;
    CGSize size = [self.textView sizeThatFits:CGSizeMake(width, MAXFLOAT)];
    self.textView.frame = CGRectMake(80+17, 20+17, width, size.height);
    [_heightArray addObject:@(ceilf(size.height) + 20 + 17 + 20 + 17)];
    
    self.tableView = [[YXNoFloatingHeaderFooterTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    [self addSubview:self.tableView];
    CGFloat top = self.bShowTitleState? 35:0;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(top, 0, 0, 0));
    }];
    
    [self.tableView registerClass:[YXQAFillBlankCell_Pad class] forCellReuseIdentifier:@"YXQAFillBlankCell_Pad"];

}

#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_heightArray[indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [_heightArray[indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_heightArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 填空题题干
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAFillBlankCell_Pad"];
    [cell.contentView addSubview:self.textView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *clearView = [[UIView alloc] initWithFrame:self.textView.frame];
    clearView.backgroundColor = [UIColor clearColor];
    [self.textView addSubview:clearView];
    [self setupFillBlanks:clearView];
    [self startLoading];// 给textfield赋值
    [cell.contentView addSubview:clearView];
    
    return cell;
}

- (NSString *)adjustText {
    if (!_adjustText) {
        NSString *pattern = @"\\(_\\)";
        NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        _adjustText = [reg stringByReplacingMatchesInString:self.data.stem
                                                    options:NSMatchingReportCompletion
                                                      range:NSMakeRange(0, [self.data.stem length])
                                               withTemplate:@"（________________）"];
    }
    return _adjustText;
}

- (void)setupFillBlanks:(UIView *)containerView {
    [_textFieldArray removeAllObjects];
    
    NSString *pattern2 = @"________________";
    NSRegularExpression *reg2 = [NSRegularExpression regularExpressionWithPattern:pattern2 options:0 error:nil];
    NSArray* match = [reg2 matchesInString:[self adjustText] options:NSMatchingReportCompletion range:NSMakeRange(0, [[self adjustText] length])];
    
    if (match.count != 0)
    {
        for (NSTextCheckingResult *matc in match)
        {
            UITextField *tf = [[UITextField alloc] init];
            tf.returnKeyType = UIReturnKeyDone;
            tf.delegate = self;
            tf.textColor = [UIColor colorWithHexString:@"00cccc"];
            tf.font = [UIFont systemFontOfSize:15];
            //tf.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
            tf.frame = [self frameOfTextRange:[matc range] inTextView:self.textView];
            [containerView addSubview:tf];
            [_textFieldArray addObject:tf];
        }
    }
}

- (CGRect)frameOfTextRange:(NSRange)range inTextView:(UITextView *)textView
{
    UITextPosition *beginning = textView.beginningOfDocument;
    UITextPosition *start = [textView positionFromPosition:beginning offset:range.location];
    UITextPosition *end = [textView positionFromPosition:start offset:range.length];
    UITextRange *textRange = [textView textRangeFromPosition:start toPosition:end];
    CGRect rect = [textView firstRectForRange:textRange];
    return [textView convertRect:rect fromView:textView.textInputView];
}
#pragma mark - height delegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    if (!ip) {
        return;
    }
    
    CGFloat h = [_heightArray[ip.row] floatValue];
    CGFloat nh = ceilf(height);
    
    if (h != nh) {
        [_heightArray replaceObjectAtIndex:ip.row withObject:@(nh)];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView layoutIfNeeded];
    }
}
#pragma mark - keyboard
- (void)hideKeyboard{
    for (UITextField *tf in _textFieldArray) {
        [tf resignFirstResponder];
    }
}
#pragma mark - uitextfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - keyboard notifications
- (void)registerKeyboardNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChangeFrameNoti:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)unRegisterKeyboardNotifications{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)keyboardChangeFrameNoti:(NSNotification *)noti{
    UITextField *currentField = nil;
    for (UITextField *tf in _textFieldArray) {
        if ([tf isFirstResponder]) {
            currentField = tf;
            break;
        }
    }
    if (!currentField) {
        return;
    }
    NSDictionary *dic = noti.userInfo;
    NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
    CGFloat top = self.bShowTitleState? 35:0;
    [UIView animateWithDuration:0.25 animations:^{
        if (keyboardFrame.origin.y == [UIScreen mainScreen].bounds.size.height) {
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(top, 0, 0, 0));
            }];
        }else{
            [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsMake(top, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y-45, 0));
            }];
        }
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        CGRect rect = [currentField convertRect:currentField.bounds toView:self.tableView];
        [self.tableView scrollRectToVisible:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height) animated:YES];
    }];
    
}


@end

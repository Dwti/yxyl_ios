//
//  QAFillBlankCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/2.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAFillBlankCell.h"
#import "QACoreTextViewStringScanner.h"
#import "QABlankItemInfo.h"
#import "QAInputAccessoryView.h"

static const NSInteger kMaxBlankWidth = 4;
static const NSInteger kBlankWidth = 3;

@interface QAFillBlankCell()<UITextViewDelegate>
@property (nonatomic, strong) DTAttributedTextContentView *htmlView;
@property (nonatomic, strong) QACoreTextViewHandler *coreTextHandler;
@property (nonatomic, strong) QACoreTextViewStringScanner *scanner;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *placeholderForPrefix;
@property (nonatomic, strong) NSMutableArray<QABlankItemInfo *> *blankItemArray;
@property (nonatomic, strong) QAInputAccessoryView *costomTextView;
@property (nonatomic, strong) UITextView *hiddenTextView;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation QAFillBlankCell

+ (CGFloat)maxContentWidth {
    return SCREEN_WIDTH-30;
}

+ (CGFloat)totalHeightWithContentHeight:(CGFloat)height{
    return height+50;
}

+ (CGFloat)heightForString:(NSString *)string {
    CGFloat maxWidth = [self maxContentWidth];
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    CGFloat stringHeight = [YXQACoreTextHelper heightForString:string options:dic width:maxWidth];
    CGFloat height = [self totalHeightWithContentHeight:stringHeight];
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.blankItemArray = [NSMutableArray array];
        self.currentIndex = -1;
        self.placeholder = @"--------";
        self.placeholderForPrefix = @"---------";
        self.scanner = [[QACoreTextViewStringScanner alloc]init];
        [self setupUI];
        [self setupObserver];
    }
    return self;
}

- (void)setupUI {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.layer.shadowRadius = 2.5;
    self.layer.shadowOpacity = 0.02;
    self.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    
    self.htmlView = [[DTAttributedTextContentView alloc] init];
    [self.contentView addSubview:self.htmlView];
    [self.htmlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(-25);
        make.right.mas_equalTo(-15);
    }];
    
    self.coreTextHandler = [[QACoreTextViewHandler alloc]initWithCoreTextView:self.htmlView maxWidth:[QAFillBlankCell maxContentWidth]];
    WEAK_SELF
    self.coreTextHandler.heightChangeBlock = ^(CGFloat height){
        STRONG_SELF
        CGFloat totalHeight = [QAFillBlankCell totalHeightWithContentHeight:height];
        [self.delegate tableViewCell:self updateWithHeight:totalHeight];
    };
    
    self.costomTextView = [[QAInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55.0f)];
    self.costomTextView.confirmBlock = ^{
        STRONG_SELF
        [self confirmClick];
    };
    
    self.hiddenTextView = [[UITextView alloc]init];
    self.hiddenTextView.hidden = YES;
    self.hiddenTextView.inputAccessoryView = self.costomTextView;
    self.hiddenTextView.delegate = self;
    [self.contentView addSubview:self.hiddenTextView];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:DTAttributedTextContentViewDidFinishLayoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        if (self.htmlView != noti.object) {
            return;
        }
        [self.blankItemArray enumerateObjectsUsingBlock:^(QABlankItemInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.scanner scanCoreTextView:self.htmlView stringRange:obj.blankRange resultBlock:^(NSArray *frameArray) {
                [self setupViewsForBlankIndex:idx frames:frameArray];
            }];
        }];
    }];
}

- (void)setupViewsForBlankIndex:(NSInteger)index frames:(NSArray *)frameArray {
    QABlankItemInfo *info = self.blankItemArray[index];
    for (UIView *v in info.viewArray) {
        [v removeFromSuperview];
    }
    if (isEmpty(info.answer)) {
        NSValue *value = frameArray.firstObject;
        CGRect rect = value.CGRectValue;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+2)];
        bgView.backgroundColor = [UIColor whiteColor];
        bgView.clipsToBounds = YES;
        UIButton *bgButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bgView.width, bgView.height+6)];
        bgButton.layer.cornerRadius = 6;
        bgButton.clipsToBounds = YES;
        [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ebebeb"]] forState:UIControlStateHighlighted];
        [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ebebeb"]] forState:UIControlStateSelected];
        [bgButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:bgButton];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-2, bgView.frame.size.width, 2)];
        line.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
        line.layer.cornerRadius = 1;
        line.clipsToBounds = YES;
        [bgView addSubview:line];
        if (!isEmpty(info.prefixLetter)) {
            UILabel *prefixLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, rect.size.height)];
            prefixLabel.text = info.prefixLetter;
            prefixLabel.font = [UIFont boldSystemFontOfSize:17];
            prefixLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
            [bgView addSubview:prefixLabel];
            [prefixLabel sizeToFit];
            CGRect lineFrame = line.frame;
            lineFrame.origin.x += prefixLabel.width;
            lineFrame.size.width -= prefixLabel.width;
            line.frame = lineFrame;
            CGRect buttonFrame = bgButton.frame;
            buttonFrame.origin.x += prefixLabel.width;
            buttonFrame.size.width -= prefixLabel.width;
            bgButton.frame = buttonFrame;
        }
        [self.htmlView addSubview:bgView];
        [info.viewArray addObject:bgView];
        bgButton.tag = 100*index;
    }else {
        [frameArray enumerateObjectsUsingBlock:^(NSValue *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            CGRect rect = obj.CGRectValue;
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height+2)];
            bgView.clipsToBounds = YES;
            UIButton *bgButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bgView.width, bgView.height+6)];
            bgButton.layer.cornerRadius = 6;
            bgButton.clipsToBounds = YES;
            [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
            [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ebebeb"]] forState:UIControlStateHighlighted];
            [bgButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"ebebeb"]] forState:UIControlStateSelected];
            [bgButton addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:bgButton];
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height-2, bgView.frame.size.width, 2)];
            line.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
            line.layer.cornerRadius = 1;
            line.clipsToBounds = YES;
            [bgView addSubview:line];
            if (idx==0 && !isEmpty(info.prefixLetter)) {
                UILabel *prefixLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, rect.size.height)];
                prefixLabel.text = info.prefixLetter;
                prefixLabel.font = [UIFont boldSystemFontOfSize:17];
                prefixLabel.textColor = [UIColor colorWithHexString:@"89e00d"];
                [prefixLabel sizeToFit];
                CGRect lineFrame = line.frame;
                lineFrame.origin.x += prefixLabel.width;
                lineFrame.size.width -= prefixLabel.width;
                line.frame = lineFrame;
                CGRect buttonFrame = bgButton.frame;
                buttonFrame.origin.x += prefixLabel.width;
                buttonFrame.size.width -= prefixLabel.width;
                bgButton.frame = buttonFrame;
            }
            [self.htmlView addSubview:bgView];
            [info.viewArray addObject:bgView];
            bgButton.tag = 100*index+idx;
        }];
    }
}

- (void)clickAction:(UIButton *)sender {
    NSInteger preIndex = self.currentIndex;
    NSInteger curIndex = sender.tag/100;
    if (preIndex>=0) {
        QABlankItemInfo *preItem = self.blankItemArray[preIndex];
        for (UIView *view in preItem.viewArray) {
            for (UIButton *b in view.subviews) {
                if ([b isKindOfClass:[UIButton class]]) {
                    b.selected = NO;
                }
            }
        }
    }
    
    self.currentIndex = curIndex;
    QABlankItemInfo *curItem = self.blankItemArray[curIndex];
    for (UIView *view in curItem.viewArray) {
        for (UIButton *b in view.subviews) {
            if ([b isKindOfClass:[UIButton class]]) {
                b.selected = YES;
            }
        }
    }
    self.costomTextView.inputTextView.text = self.question.myAnswers[self.currentIndex];
    if (![self.costomTextView.inputTextView isFirstResponder]) {
        [self.hiddenTextView becomeFirstResponder];
    }
}

- (void)setQuestion:(QAQuestion *)question {
    _question = question;
    [self refresh];
}

- (void)refresh {
    NSAttributedString *attrString = [self attrStringForString:self.question.stem];
    NSString *plainString = [attrString plainTextString];
    
    NSRegularExpression *reg = [self regForBlank];
    NSArray<NSTextCheckingResult *> *results = [reg matchesInString:plainString options:NSMatchingReportCompletion range:NSMakeRange(0, plainString.length)];
    
    for (QABlankItemInfo *info in self.blankItemArray) {
        for (UIView *v in info.viewArray) {
            [v removeFromSuperview];
        }
    }
    [self.blankItemArray removeAllObjects];
    __block NSInteger locationOffset = 0;
    [results enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = obj.range;
        if (range.length > kMaxBlankWidth) {
            range = NSMakeRange(range.location+range.length-kBlankWidth, kBlankWidth);
        }
        QABlankItemInfo *info = [[QABlankItemInfo alloc]init];
        info.placeholder = self.placeholder;
        info.answer = self.question.myAnswers[idx];
        if (range.length == kMaxBlankWidth) {
            info.prefixLetter = [plainString substringWithRange:NSMakeRange(range.location, 1)];
            info.placeholder = self.placeholderForPrefix;
        }
        NSRange blankRange = NSMakeRange(range.location+locationOffset, info.displayedString.length);
        info.blankRange = blankRange;
        [self.blankItemArray addObject:info];
        locationOffset += (info.displayedString.length-range.length);
    }];
    
    NSString *finalStem = self.question.stem;
    NSTextCheckingResult *result = [reg firstMatchInString:finalStem options:NSMatchingReportCompletion range:NSMakeRange(0, finalStem.length)];
    NSInteger index = 0;
    while (result) {
        QABlankItemInfo *info = self.blankItemArray[index];
        NSString *template;
        if (isEmpty(info.answer)) {
            template = info.placeholder;
        }else {
            template = [self blankAnswerHtmlStringWithString:info.displayedString];
        }
        
        NSRange range = result.range;
        if (range.length > kMaxBlankWidth) {
            range = NSMakeRange(range.location+range.length-kBlankWidth, kBlankWidth);
        }
        
        finalStem = [reg stringByReplacingMatchesInString:finalStem
                                                  options:NSMatchingReportCompletion
                                                    range:range
                                             withTemplate:template];
        result = [reg firstMatchInString:finalStem options:NSMatchingReportCompletion range:NSMakeRange(0, finalStem.length)];
        index++;
    }
    
    self.htmlView.attributedString = [self attrStringForString:finalStem];
}

- (NSAttributedString *)attrStringForString:(NSString *)string {
    NSDictionary *dic = [YXQACoreTextHelper defaultOptionsForLevel1];
    return [YXQACoreTextHelper attributedStringWithString:string options:dic];
}

- (NSRegularExpression *)regForBlank {
    NSString *pattern = @"[a-zA-Z]{0,}\\(_\\)";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    return reg;
}

- (NSString *)blankAnswerHtmlStringWithString:(NSString *)string {
    return [NSString stringWithFormat:@"<font color=\"#89E00D\">%@</font>",string];
}

- (void)confirmClick {
    if (![self.costomTextView.inputTextView.text isEqualToString:self.question.myAnswers[self.currentIndex]]) {
        YXQAAnswerState fromState = [self.question answerState];
        NSString *answer = [self.costomTextView.inputTextView.text nyx_stringByTrimmingExtraSpaces];
        [self.question.myAnswers replaceObjectAtIndex:self.currentIndex withObject:answer];
        YXQAAnswerState toState = [self.question answerState];
        if (fromState != toState && [self.answerStateChangeDelegate respondsToSelector:@selector(question:didChangeAnswerStateFrom:to:)]) {
            [self.answerStateChangeDelegate question:self.question didChangeAnswerStateFrom:fromState to:toState];
        }
        [self refresh];
    }else {
        QABlankItemInfo *curItem = self.blankItemArray[self.currentIndex];
        for (UIView *view in curItem.viewArray) {
            for (UIButton *b in view.subviews) {
                if ([b isKindOfClass:[UIButton class]]) {
                    b.selected = NO;
                }
            }
        }
    }
    [self endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.hiddenTextView) {
        [self.costomTextView.inputTextView becomeFirstResponder];
    }
}

@end

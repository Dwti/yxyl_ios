//
//  QAFillQuestionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/8.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAFillQuestionCell.h"
#import "QACoreTextViewStringScanner.h"

@interface QAFillQuestionCell () <UITextFieldDelegate>
@property (nonatomic, strong) QACoreTextViewStringScanner *scanner;
@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *placeholderViewArray;
@end

@implementation QAFillQuestionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.scanner = [[QACoreTextViewStringScanner alloc]init];
        [self setupObserver];
    }
    return self;
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:DTAttributedTextContentViewDidFinishLayoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        if (self.htmlView != noti.object) {
            return;
        }
        [self.scanner scanCoreTextView:self.htmlView string:self.placeHolder scanBlock:^(NSInteger index, NSInteger total, CGRect frame) {
            if (!self.placeholderViewArray) {
                self.placeholderViewArray = [NSMutableArray array];
                for (int i=0; i<total; i++) {
                    [self.placeholderViewArray addObject:[self placeHolderViewWithIndex:i]];
                }
            }
            CGRect rect =  CGRectMake(floorf(frame.origin.x), floorf(frame.origin.y)-2, ceilf(frame.size.width+1), ceilf(frame.size.height+1)+3);
            UIView *v = self.placeholderViewArray[index];
            v.frame = rect;
            [self.htmlView addSubview:v];
        }];
    }];
}

- (UIView *)placeHolderViewWithIndex:(NSInteger)index {
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.cornerRadius = 7;
    bgView.layer.borderColor = [UIColor colorWithRGBHex:0xffe580].CGColor;
    bgView.backgroundColor = [UIColor colorWithRGBHex:0xffe580];
    bgView.layer.borderWidth = 2;
    bgView.layer.masksToBounds = YES;
    
    UITextField *textField = [UITextField new];
    textField.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont fontWithName:@"Times New Roman" size:15];
    textField.textColor = [UIColor blackColor];
    textField.returnKeyType = UIReturnKeyDone;
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    view.size = CGSizeMake(5, textField.height);
    
    textField.rightView = view;
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    textField.delegate = self;
    if ([self.item.myAnswers[index] length]) {
        textField.text = self.item.myAnswers[index];
    }
    bgView.backgroundColor = [UIColor colorWithRGBHex:[textField.text length]? 0xffffff: 0xffe580];
    WEAK_SELF
    [[textField rac_textSignal] subscribeNext:^(id x) {
        STRONG_SELF
        [self.item.myAnswers replaceObjectAtIndex:index withObject:[x yx_stringByTrimmingCharacters]];
        [self executeRedoStatusDelegate];
    }];
    [bgView addSubview:textField];
    
    return bgView;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.superview.backgroundColor = [UIColor colorWithRGBHex:0xffffff];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.superview.backgroundColor = [UIColor colorWithRGBHex:[textField.text length]? 0xffffff: 0xffe580];
}

- (void)setItem:(QAQuestion *)item{
    if (self.item == item) {
        return;
    }
    [super setItem:item];
    NSString *template = [NSString stringWithFormat:@" %@ ", self.placeHolder];
    NSString *adjustString = [QAQuestionUtil stringByReplacingUnderlineInsideParentheses:item.stem template:template];

    self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:adjustString];
}

- (void)executeRedoStatusDelegate {
    if (self.redoStatusDelegate && [self.redoStatusDelegate respondsToSelector:@selector(updateRedoStatus)]) {
        [self.redoStatusDelegate updateRedoStatus];
    }
}

@end

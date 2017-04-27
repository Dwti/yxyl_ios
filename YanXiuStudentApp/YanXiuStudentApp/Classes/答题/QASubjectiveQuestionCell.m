//
//  QASubjectiveQuestionCell.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/21.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QASubjectiveQuestionCell.h"
#import "QACoreTextViewStringScanner.h"
#include "QASubjectiveFillPlaceholderView.h"

@interface QASubjectiveQuestionCell ()
@property (nonatomic, strong) QACoreTextViewStringScanner *scanner;
@property (nonatomic, strong) NSMutableArray<__kindof UIView *> *placeholderViewArray;
@end

@implementation QASubjectiveQuestionCell

- (void)setItem:(QAQuestion *)item{
    if (self.item == item) {
        return;
    }
    [super setItem:item];
    if (item.questionType == YXQAItemFill||
        item.questionType == YXQAItemListenFill||
        item.questionType == YXQAItemListenAudioFill||
        item.questionType == YXQAItemTranslate) {
        NSString *adjustString = [QAQuestionUtil stringByReplacingUnderlineInsideParentheses:item.stem template:@" ____ "];
        self.htmlView.attributedString = [YXQACoreTextHelper attributedStringForString:adjustString];
        
        self.scanner = [[QACoreTextViewStringScanner alloc]init];
        [self setupObserver];
    }
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:DTAttributedTextContentViewDidFinishLayoutNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = x;
        if (self.htmlView != noti.object) {
            return;
        }
        [self.scanner scanCoreTextView:self.htmlView string:@"____" scanBlock:^(NSInteger index, NSInteger total, CGRect frame) {
            [self setupPlaceholderViewsIfNeeded:total];
            UIView *v = self.placeholderViewArray[index];
            CGRect rect = CGRectMake(floorf(frame.origin.x), floorf(frame.origin.y), ceilf(frame.size.width+1), ceilf(frame.size.height+1));
            v.frame = rect;
            [self.htmlView addSubview:v];
        }];
    }];
}

- (void)setupPlaceholderViewsIfNeeded:(NSInteger)count {
    if (!self.placeholderViewArray) {
        self.placeholderViewArray = [NSMutableArray array];
        for (int i=0; i<count; i++) {
            QASubjectiveFillPlaceholderView *view = [self placeHolderViewWithIndex:i];
            if (count == 1) {
                view.indexHidden = YES;
            }
            [self.placeholderViewArray addObject:view];
        }
    }
}

- (QASubjectiveFillPlaceholderView *)placeHolderViewWithIndex:(NSInteger)index {
    QASubjectiveFillPlaceholderView *view = [[QASubjectiveFillPlaceholderView alloc]init];
    view.index = index;
    return view;
}

@end

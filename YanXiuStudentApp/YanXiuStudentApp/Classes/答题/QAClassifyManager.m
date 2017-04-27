//
//  QAClassifyManager.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAClassifyManager.h"

@interface QAClassifyManager()
@property (nonatomic, copy) OptionChangeBlock changeBlock;
@end

@implementation QAClassifyManager

#pragma mark- Get
- (UIView *)currentView{
    return self.optionsCell.optionsView.currentView;
}

#pragma mark- Set
- (void)setCurrentView:(UIView *)currentView{
    self.optionsCell.optionsView.currentView = currentView;
}

- (void)setData:(QAQuestion *)data{
    _data = data;
    self.options = [NSMutableArray array];
    NSRange range = [self.data.options.firstObject rangeOfString:@"img src=.*\\.(jpg|png|jpeg)" options:NSRegularExpressionSearch];
    self.type = range.location != NSNotFound? OptionsImageDataType: OptionsStringDataType;
    [self sortOptions];
}

- (void)setClassesView:(YXClassesView *)classesView{
    _classesView = classesView;
    WEAK_SELF
    _classesView.touchClasses = ^(NSInteger index){
        STRONG_SELF
        QANumberGroupAnswer *item = self.data.myAnswers[index];
        if (self.currentView) {//归类操作
            item.answers[self.currentIndex] = @(1);
            self.currentView = nil;
            [self sortOptions];
            self.optionsCell.optionsView.datas = self.options;
            [self.classesView reloadData];
            BLOCK_EXEC(self.changeBlock);
        }else{//没有选项被选中 看已作答的答案
            self.currentClassesIndex = index;
            QANumberGroupAnswer *groupAnswer = self.data.myAnswers[index];
            if ([self totalWithAnwers:groupAnswer.answers]) {//有答案才显示
                NSMutableArray *datas = [NSMutableArray new];
                [item.answers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj integerValue]) {
                        [datas addObject:self.data.options[idx]];
                    }
                }];
                self.answersView.title = [YXClassesView titleWithItem:self.data.myAnswers[index]];
                self.answersView.datas = datas;
                [self.answersView show];
            }
        }
    };
}

- (void)setAnswersView:(QAClassifyAnswersView *)answersView{
    _answersView = answersView;
    WEAK_SELF
    [_answersView setDeleteBlock:^(id obj) {
        STRONG_SELF
        NSInteger index = [self.data.options indexOfObject:obj];
        QANumberGroupAnswer *item = self.data.myAnswers[self.currentClassesIndex];
        item.answers[index] = @(0);
        self.answersView.title = [YXClassesView titleWithItem:self.data.myAnswers[self.currentClassesIndex]];
        [self.answersView.datas removeObject:obj];
        self.answersView.datas = self.answersView.datas;
        [self sortOptions];
        [self.classesView reloadData];
        if ([self totalWithAnwers:item.answers] == 0) {
            [self.answersView hide];
        }
        BLOCK_EXEC(self.changeBlock);
    }];
}

- (void)setOptionsCell:(QAClassifyOptionsCell *)optionsCell{
    [self sortOptions];

    _optionsCell = optionsCell;
    WEAK_SELF
    [_optionsCell.optionsView setInsertBlock:^(id obj) {
        STRONG_SELF
        self.currentIndex = [self.data.options indexOfObject:obj];
    }];
}

#pragma mark-
- (void)sortOptions{
    [self.options removeAllObjects];
    for (int i = 0; i < self.data.options.count; i++) {
        BOOL selected = NO;
        for (int j = 0; j < self.data.myAnswers.count; j++) {
            QANumberGroupAnswer *item = self.data.myAnswers[j];
            if ([item.answers[i] integerValue]) {
                selected = YES;
                break;
            }
        }
        if (!selected) {
            [self.options addObject:self.data.options[i]];
        }
    }
    self.optionsCell.optionsView.datas = self.options;
    
    [self executeRedoStatusDelegate];
}

- (void)executeRedoStatusDelegate {
    if (self.redoStatusDelegate && [self.redoStatusDelegate respondsToSelector:@selector(updateRedoStatus)]) {
        [self.redoStatusDelegate updateRedoStatus];
    }
}

- (long)totalWithAnwers:(NSArray *)anwers{
    long total = 0;
    for (NSNumber *result in anwers) {
        if (result.longLongValue) {
            total++;
        }
    }
    return total;
}

- (void)setOptionChangeBlock:(OptionChangeBlock)block {
    self.changeBlock = block;
}

@end

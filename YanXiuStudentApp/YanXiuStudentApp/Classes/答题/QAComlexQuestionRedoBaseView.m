//
//  QAComlexQuestionRedoBaseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAComlexQuestionRedoBaseView.h"
#import "QARedoSubmitView.h"

@interface QAComlexQuestionRedoBaseView()
@property (nonatomic, strong) QARedoSubmitView *submitView;
@property (nonatomic, strong) NSMutableArray<__kindof RACDisposable *> *disposeArray;
@end

@implementation QAComlexQuestionRedoBaseView
- (void)dealloc {
    [self.disposeArray enumerateObjectsUsingBlock:^(__kindof RACDisposable * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj dispose];
    }];
}

- (void)setupUI {
    [super setupUI];
    [self setupObserver];
}

- (void)setupObserver {
    self.disposeArray = [NSMutableArray array];
    WEAK_SELF
    RACDisposable *dispose = [RACObserve(self.data, redoStatus) subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshForRedoStatusChange];
        NSNumber *num = x;
        QARedoStatus status = num.integerValue;
        if (status == QARedoStatus_CanDelete) {
            for (QAQuestion *q in self.data.childQuestions) {
                q.redoStatus = status;
            }
        }
    }];
    [self.disposeArray addObject:dispose];
    
    for (QAQuestion * q in self.data.childQuestions) {
        RACDisposable *dispose = [RACObserve(q, redoStatus) subscribeNext:^(id x) {
            STRONG_SELF
            NSInteger initCount = 0;
            NSInteger canSubmitCount = 0;
            for (QAQuestion *subQ in self.data.childQuestions) {
                if (subQ.redoStatus == QARedoStatus_Init) {
                    initCount++;
                }else if (subQ.redoStatus == QARedoStatus_CanSubmit||subQ.redoStatus == QARedoStatus_ShowAnalysis) {
                    canSubmitCount++;
                }else {
                    break;
                }
            }
            if (initCount+canSubmitCount != self.data.childQuestions.count) {
                return;
            }
            if (initCount == 0) {
                self.data.redoStatus = QARedoStatus_CanSubmit;
            }else {
                self.data.redoStatus = QARedoStatus_Init;
            }
        }];
        [self.disposeArray addObject:dispose];
    }
}

- (void)refreshForRedoStatusChange {
    
}

#pragma mark - slide tab datasource delegate
- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestion *data = [self.data.childQuestions objectAtIndex:index];
    data.wrongQuestionID = self.data.wrongQuestionID;
    
    QAQuestionViewContainer *container = [QAQuestionViewContainerFactory containerWithQuestion:data];
    QAQuestionBaseView *view = [container questionRedoView];
    view.data = data;
    view.isPaperSubmitted = self.isPaperSubmitted;
    view.isSubQuestionView = YES;
    view.analysisDataDelegate = self.analysisDataDelegate;
    view.delegate = self;
    view.editNoteDelegate = self.editNoteDelegate;
    
    return view;
}

#pragma mark - YXAutoGoNextDelegate
- (void)autoGoNextGoGoGo {
    if (self.slideView.currentIndex == ([self.data.childQuestions count] - 1)) {
        return;
    }
    [self.slideView scrollToItemIndex:self.slideView.currentIndex+1 animated:YES];
}

@end

//
//  QAClozeComplexView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/24/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAClozeComplexView.h"
#import "QAClozeContainerView.h"

@interface QAClozeComplexView() <QAClozeQuestionCellDelegate>

@property (nonatomic, strong) QAClozeContainerView *clozeContainerView;

@end


@implementation QAClozeComplexView

- (UIView *)topContainerView {
    self.clozeContainerView = [[QAClozeContainerView alloc] initWithData:self.data];
    self.clozeContainerView.currentIndex = self.nextLevelStartIndex;
    self.clozeContainerView.delegate = self;
    self.clozeContainerView.isAnalysis = NO;
    return self.clozeContainerView;
}

#pragma mark- QAClozeContainerViewDelegate
- (void)didSelectItemAtIndex:(NSInteger)index {
    [self.slideView scrollToItemIndex:index animated:YES];
}

- (void)layoutRefreshed {
    [self.clozeContainerView.tableView scrollRectToVisible:[self.clozeContainerView.clozeCell.selectedButton convertRect:self.clozeContainerView.clozeCell.selectedButton.bounds toView:self.clozeContainerView.tableView] animated:YES];
}

#pragma mark- SliderView
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [super slideView:slideView didSlideFromIndex:from toIndex:to];

    if (to < self.clozeContainerView.clozeCell.buttonArray.count) {
        self.clozeContainerView.clozeCell.selectedButton = self.clozeContainerView.clozeCell.buttonArray[to];
        [self.clozeContainerView.tableView scrollRectToVisible:[self.clozeContainerView.clozeCell.selectedButton convertRect:self.clozeContainerView.clozeCell.selectedButton.bounds toView:self.clozeContainerView.tableView] animated:YES];
    }
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestionBaseView *view = (QAQuestionBaseView *)[super slideView:slideView itemViewAtIndex:index];
    view.hideQuestion = YES;
    return view;
}

- (void)autoGoNextGoGoGo {
    [super autoGoNextGoGoGo];
    if ([self.clozeContainerView.clozeCell.buttonArray containsObject:self.clozeContainerView.clozeCell.selectedButton]) {
        [self.clozeContainerView.clozeCell selectAnswerWithQuestion:[self.clozeContainerView.clozeCell.buttonArray indexOfObject:self.clozeContainerView.clozeCell.selectedButton]];
    }
}

- (void)cancelAnswer {
    [self.clozeContainerView.clozeCell selectAnswerWithQuestion:[self.clozeContainerView.clozeCell.buttonArray indexOfObject:self.clozeContainerView.clozeCell.selectedButton]];
}

@end

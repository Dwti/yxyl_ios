//
//  QARedoClozeComplexView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QARedoClozeComplexView.h"
#import "QAClozeContainerView.h"

@interface QARedoClozeComplexView()<QAClozeQuestionCellDelegate>
@property (nonatomic, strong) QAClozeContainerView *clozeContainerView;
@end

@implementation QARedoClozeComplexView

- (UIView *)topContainerView {
    self.clozeContainerView = [[QAClozeContainerView alloc] initWithData:self.data];
    self.clozeContainerView.currentIndex = self.nextLevelStartIndex;
    self.clozeContainerView.delegate = self;
    return self.clozeContainerView;
}

#pragma mark- QAClozeContainerViewDelegate
- (void)didSelectItemAtIndex:(NSInteger)index {
    [self.slideView scrollToItemIndex:index animated:YES];
}

- (void)layoutRefreshed {
    [self.clozeContainerView scrollCurrentBlankToVisible];
}

#pragma mark- SliderView
- (void)slideView:(QASlideView *)slideView didSlideFromIndex:(NSInteger)from toIndex:(NSInteger)to {
    [super slideView:slideView didSlideFromIndex:from toIndex:to];
    
    self.clozeContainerView.clozeCell.currentIndex = to;
    [self.clozeContainerView scrollCurrentBlankToVisible];
}

- (QASlideItemBaseView *)slideView:(QASlideView *)slideView itemViewAtIndex:(NSInteger)index {
    QAQuestionBaseView *view = (QAQuestionBaseView *)[super slideView:slideView itemViewAtIndex:index];
    view.hideQuestion = YES;
    view.delegate = self;
    return view;
}

- (void)autoGoNextGoGoGo {
    [super autoGoNextGoGoGo];
    [self.clozeContainerView.clozeCell refresh];
    self.clozeContainerView.clozeCell.currentIndex = MIN(self.clozeContainerView.clozeCell.currentIndex+1, self.data.childQuestions.count-1);
}

- (void)cancelAnswer {
    [self.clozeContainerView.clozeCell refresh];
}

@end

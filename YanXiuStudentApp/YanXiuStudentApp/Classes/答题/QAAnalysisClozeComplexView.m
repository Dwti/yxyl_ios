//
//  QAAnalysisClozeComplexView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/26/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAAnalysisClozeComplexView.h"
#import "QAClozeContainerView.h"


@interface QAAnalysisClozeComplexView () <QAClozeQuestionCellDelegate>

@property (nonatomic, strong) QAClozeContainerView *clozeContainerView;

@end


@implementation QAAnalysisClozeComplexView

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
    return view;
}

@end

//
//  QAClozeComplexView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/24/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAClozeComplexView.h"
#import "QAClozeContainerView.h"

static const CGFloat kClozeOptionsHeight = 256+45;

@interface QAClozeComplexView() <QAClozeQuestionCellDelegate>

@property (nonatomic, strong) QAClozeContainerView *clozeContainerView;

@end


@implementation QAClozeComplexView

- (void)setupUI {
    [super setupUI];
    [self.middleContainerView removeFromSuperview];
    [self.upContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.downContainerView.mas_top);
    }];
    [self.downContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.upContainerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(kClozeOptionsHeight);
    }];
}

- (UIView *)topContainerView {
    self.clozeContainerView = [[QAClozeContainerView alloc] initWithData:self.data];
    self.clozeContainerView.currentIndex = self.nextLevelStartIndex;
    self.clozeContainerView.delegate = self;
    return self.clozeContainerView;
}

#pragma mark- QAClozeQuestionCellDelegate
- (void)didSelectItemAtIndex:(NSInteger)index {
    if ([self isDownContainerHidden]) {
        [self.slideView scrollToItemIndex:index animated:NO];
        [self.slideView layoutIfNeeded];
        [UIView animateWithDuration:0.3 animations:^{
            [self.downContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.upContainerView.mas_bottom);
                make.left.right.bottom.mas_equalTo(0);
                make.height.mas_equalTo(kClozeOptionsHeight);
            }];
            [self layoutIfNeeded];
        }completion:^(BOOL finished) {
            [self.clozeContainerView scrollCurrentBlankToVisible];
        }];
    }else {
        [self.slideView scrollToItemIndex:index animated:YES];
    }
}

- (void)layoutRefreshed {
    [self.clozeContainerView scrollCurrentBlankToVisible];
}

- (void)stemClicked {
    if ([self isDownContainerHidden]) {
        return;
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self.downContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.upContainerView.mas_bottom);
            make.left.right.bottom.height.mas_equalTo(0);
        }];
        [self layoutIfNeeded];
    }];
}

- (BOOL)isDownContainerHidden {
    return self.downContainerView.y > SCREEN_HEIGHT-kClozeOptionsHeight;
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

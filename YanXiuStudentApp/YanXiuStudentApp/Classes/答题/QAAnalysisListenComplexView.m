//
//  QAAnalysisListenComplexView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/26/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAAnalysisListenComplexView.h"
#import "QAListenContainerView.h"

@interface QAAnalysisListenComplexView ()

@property (nonatomic, strong) QAListenContainerView *listenContainerView;

@end


@implementation QAAnalysisListenComplexView

- (UIView *)topContainerView {
    self.listenContainerView = [[QAListenContainerView alloc] initWithData:self.data];
    return self.listenContainerView;
}

- (void)leaveForeground {
    [super leaveForeground];
    [self.listenContainerView.cell stop];
}

@end

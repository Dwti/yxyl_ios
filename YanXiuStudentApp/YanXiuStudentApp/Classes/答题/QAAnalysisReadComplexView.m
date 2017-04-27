//
//  QAAnalysisReadComplexView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/26/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAAnalysisReadComplexView.h"
#import "QAReadContainerView.h"

@interface QAAnalysisReadComplexView ()

@property (nonatomic, strong) QAReadContainerView *readContainerView;

@end


@implementation QAAnalysisReadComplexView

- (UIView *)topContainerView {
    self.readContainerView = [[QAReadContainerView alloc] initWithData:self.data];
    return self.readContainerView;
}

@end

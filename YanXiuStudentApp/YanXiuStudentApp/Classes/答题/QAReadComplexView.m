//
//  QAReadComplexView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/24/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAReadComplexView.h"
#import "QAReadContainerView.h"

@interface QAReadComplexView ()

@property (nonatomic, strong) QAReadContainerView *readContainerView;

@end


@implementation QAReadComplexView

- (UIView *)topContainerView {
    self.readContainerView = [[QAReadContainerView alloc] initWithData:self.data];
    return self.readContainerView;
}

@end

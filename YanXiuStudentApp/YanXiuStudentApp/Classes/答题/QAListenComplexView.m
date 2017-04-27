//
//  QAListenComplexView.m
//  YanXiuStudentApp
//
//  Created by FanYu on 10/24/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "QAListenComplexView.h"
#import "QAListenContainerView.h"
#import "QAListenComplexCell.h"

@interface QAListenComplexView()

@property (nonatomic, strong) QAListenContainerView *listenContainerView;

@end


@implementation QAListenComplexView

- (UIView *)topContainerView {
    self.listenContainerView = [[QAListenContainerView alloc] initWithData:self.data];
    return self.listenContainerView;
}

- (void)leaveForeground {
    [super leaveForeground];
    [self.listenContainerView.cell stop];
}

@end

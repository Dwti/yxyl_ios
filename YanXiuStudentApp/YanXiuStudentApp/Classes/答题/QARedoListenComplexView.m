//
//  QARedoListenComplexView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QARedoListenComplexView.h"
#import "QAListenContainerView.h"

@interface QARedoListenComplexView()
@property (nonatomic, strong) QAListenContainerView *listenContainerView;
@end

@implementation QARedoListenComplexView

- (UIView *)topContainerView {
    self.listenContainerView = [[QAListenContainerView alloc] initWithData:self.data];
    return self.listenContainerView;
}

- (void)leaveForeground {
    [super leaveForeground];
    [self.listenContainerView.cell stop];
}

@end

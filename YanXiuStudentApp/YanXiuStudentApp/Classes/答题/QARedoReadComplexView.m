//
//  QARedoReadComplexView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/1/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QARedoReadComplexView.h"
#import "QAReadContainerView.h"

@interface QARedoReadComplexView()
@property (nonatomic, strong) QAReadContainerView *readContainerView;
@end

@implementation QARedoReadComplexView

- (UIView *)topContainerView {
    self.readContainerView = [[QAReadContainerView alloc] initWithData:self.data];
    return self.readContainerView;
}

@end

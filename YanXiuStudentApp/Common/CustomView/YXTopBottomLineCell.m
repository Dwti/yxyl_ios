//
//  YXTopBottomLineCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/8/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXTopBottomLineCell.h"

@implementation YXTopBottomLineCell {
    UIView *_topSepView;
    UIView *_bottomSepView;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_topSepView) {
        _topSepView = [[UIView alloc] init];
        _topSepView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        _bottomSepView = [[UIView alloc] init];
        _bottomSepView.backgroundColor = [UIColor colorWithHexString:@"e2e2e2"];
        if (self.lineColor) {
            _topSepView.backgroundColor = self.lineColor;
            _bottomSepView.backgroundColor = self.lineColor;
        }
        
        [self addSubview:_topSepView];
        [self addSubview:_bottomSepView];
        
        if ((self.topInsets.left < 0) || (self.topInsets.right < 0)) {
            _topSepView.hidden = YES;
        }
        
        if ((self.bottomInsets.left < 0) || (self.bottomInsets.right < 0)) {
            _bottomSepView.hidden = YES;
        }
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
            _topSepView.frame = CGRectMake(_topInsets.left, 0, CGRectGetWidth(self.bounds) - _topInsets.left - _topInsets.right, 0.5f);
            _bottomSepView.frame = CGRectMake(_bottomInsets.left, CGRectGetHeight(self.bounds) - 0.5f, CGRectGetWidth(self.bounds) - _bottomInsets.left - _bottomInsets.right, 0.5f);
        } else {
            [_topSepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
                make.left.mas_equalTo(_topInsets.left);
                make.right.mas_equalTo(-_topInsets.right);
            }];
            
            [_bottomSepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
                make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
                make.left.mas_equalTo(_bottomInsets.left);
                make.right.mas_equalTo(-_bottomInsets.right);
            }];
        }
    }
}

@end

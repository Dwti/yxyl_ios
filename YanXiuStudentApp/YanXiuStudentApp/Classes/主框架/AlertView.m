//
//  AlertView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/11/14.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "AlertView.h"

@interface AlertView ()
@property (nonatomic, strong) UIView *maskView;
@end

@implementation AlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupMaskView];
        self.hideWhenMaskClicked = NO;
        self.maskColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return self;
}

#pragma mark - maskView
- (void)setupMaskView {
    UIView *maskView = [[UIView alloc]init];
    self.maskView = maskView;
    [self addSubview:self.maskView];
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.maskView addGestureRecognizer:tapGesture];
}

-(void)tapGesture:(UITapGestureRecognizer *)sender {
    [self hide];
}

#pragma mark - show
- (void)showWithLayout:(LayoutBlock)layoutBlock {
    [self showInView:[UIApplication sharedApplication].keyWindow withLayout:layoutBlock];
}

- (void)showInView:(UIView *)view withLayout:(LayoutBlock)layoutBlock {
    if (!self.contentView) {
        return;
    }
    [self addSubview:self.contentView];
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    BLOCK_EXEC(layoutBlock,self);
}

#pragma mark - hide
- (void)hide {
    if (self.hideBlock) {
        self.hideBlock(self);
    }else {
        [self removeFromSuperview];
    }
}

#pragma mark - set
- (void)setHideWhenMaskClicked:(BOOL)hideWhenMaskClicked {
    _hideWhenMaskClicked = hideWhenMaskClicked;
    self.maskView.userInteractionEnabled = hideWhenMaskClicked;
}

- (void)setMaskColor:(UIColor *)maskColor {
    _maskColor = maskColor;
    self.maskView.backgroundColor = maskColor;
}

@end

//
//  EEAlertView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2016/12/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "EEAlertView.h"
CGFloat const kDefaultContentViewWith = 270;

@interface EEAlertButtonItem : NSObject
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) ButtonActionBlock block;
@end

@implementation EEAlertButtonItem
@end

@interface EEAlertView ()
@property (nonatomic, strong) NSMutableArray<EEAlertButtonItem *> *alertButtonItems;//有1~2个按钮
@end

@implementation EEAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alertButtonItems = [NSMutableArray array];
        self.hideAlertWhenButtonTapped = YES;
    }
    return self;
}

#pragma mark - addButton
- (void)addButtonWithTitle:(NSString *)title action:(ButtonActionBlock)buttonActionBlock {
    if (self.alertButtonItems.count > 2) {
        return;
    }
    EEAlertButton *button = [[EEAlertButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    EEAlertButtonItem *item = [[EEAlertButtonItem alloc]init];
    item.button = button;
    item.block = buttonActionBlock;
    [self.alertButtonItems addObject:item];
}

- (void)buttonAction:(EEAlertButton *)sender {
    if (self.hideAlertWhenButtonTapped) {
        [self hide];
    }
    [self.alertButtonItems enumerateObjectsUsingBlock:^(EEAlertButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([sender isEqual:obj.button]) {
            BLOCK_EXEC(obj.block);
            *stop = YES;
        }
    }];
}

#pragma mark - show
- (void)show {
    [self show:YES];
}

- (void)show:(BOOL)animated {
    [self showInView:[UIApplication sharedApplication].keyWindow animated:animated] ;
}

- (void)showInView:(UIView *)view {
    [self showInView:view animated:YES];
}

- (void)showInView:(UIView *)view animated:(BOOL)animated {
        LayoutBlock block = ^(AlertView *view) {
            [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self);
                make.width.mas_equalTo(kDefaultContentViewWith);
            }];
            if (animated) {
                self.alpha = 0.3;
                NSTimeInterval duration = animated ? 0.3f : 0;
                [UIView animateWithDuration:duration animations:^{
                    self.alpha = 1.f;
                }];
            }
        };
    if (!self.contentView) {
        self.contentView = [self generateDefaultView];
    }
    [self showInView:view withLayout:block];
}

#pragma mark - defaultContentView
- (UIView *)generateDefaultView {
    UIView *defaultView = [[UIView alloc]init];
    EEAlertContentBackgroundImageView *contentBGView = [[EEAlertContentBackgroundImageView alloc]init];
    EEAlertTipImageView *tipIconView = [[EEAlertTipImageView alloc]init];
    EEAlertTitleLabel *titleLabel = [[EEAlertTitleLabel alloc]init];
    titleLabel.text = self.title;
    EEAlertDottedLineView *dottedLineView = [[EEAlertDottedLineView alloc]init];
    UIView *bottomView = [[UIView alloc]init];
    
    [defaultView addSubview:contentBGView];
    [defaultView addSubview:tipIconView];
    [defaultView addSubview:titleLabel];
    [defaultView addSubview:dottedLineView];
    [defaultView  addSubview:bottomView];
    [contentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(defaultView);
    }];
    [tipIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(defaultView).offset(15);
        make.top.equalTo(defaultView).offset(15);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tipIconView.mas_right).offset(10);
        make.top.equalTo(tipIconView).offset(3);
        make.right.mas_lessThanOrEqualTo(defaultView).offset(-20);
    }];
    [dottedLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(defaultView).offset(5);
        make.right.equalTo(defaultView).offset(-5);
        make.height.mas_equalTo(1);
        make.top.equalTo(titleLabel.mas_bottom).offset(8);
    }];
    [self.alertButtonItems enumerateObjectsUsingBlock:^(EEAlertButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj.button;
        [bottomView addSubview:button];
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(defaultView);
        make.top.equalTo(dottedLineView.mas_bottom).offset(15);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(defaultView).offset(-20);
    }];
    NSInteger buttonCount = bottomView.subviews.count;
    CGFloat buttonHeight = 40;
    if (buttonCount == 1) {
        CGFloat buttonWith = 214;
        [bottomView.subviews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.centerY.equalTo(bottomView);
            make.size.mas_equalTo(CGSizeMake(buttonWith,buttonHeight));
        }];
    }
    if (buttonCount == 2) {
        CGFloat buttonWith = 107;
        CGFloat margin = (CGFloat)(kDefaultContentViewWith - buttonCount * buttonWith)/(buttonCount + 1);
        [bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(bottomView).offset((buttonWith + margin) * idx + margin);
                make.centerY.equalTo(bottomView);
                make.width.mas_equalTo(buttonWith);
                make.height.mas_equalTo(buttonHeight);
            }];
        }];
    }
    return  defaultView;
}
@end

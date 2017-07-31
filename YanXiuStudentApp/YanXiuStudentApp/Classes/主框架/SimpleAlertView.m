//
//  SimpleAlertView.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/4.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SimpleAlertView.h"

CGFloat const kQADefaultContentViewWith = 327;

@interface SimpleAlertButtonItem : NSObject
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, copy) ButtonActionBlock block;
@end

@implementation SimpleAlertButtonItem
@end

@interface SimpleAlertView ()
@property (nonatomic, strong) NSMutableArray<SimpleAlertButtonItem *> *alertButtonItems;//有1~2个按钮
@end

@implementation SimpleAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.alertButtonItems = [NSMutableArray array];
        self.hideAlertWhenButtonTapped = YES;
    }
    return self;
}

#pragma mark - addButton
- (void)addButtonWithTitle:(NSString *)title style:(SimpleAlertActionStyle)style action:(ButtonActionBlock)buttonActionBlock {
    if (self.alertButtonItems.count > 2) {
        return;
    }
    SimpleAlertButton *button = [[SimpleAlertButton alloc]init];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.style = style;
    SimpleAlertButtonItem *item = [[SimpleAlertButtonItem alloc]init];
    item.button = button;
    item.block = buttonActionBlock;
    [self.alertButtonItems addObject:item];
}

- (void)buttonAction:(SimpleAlertButton *)sender {
    if (self.hideAlertWhenButtonTapped) {
        [self hide];
    }
    [self.alertButtonItems enumerateObjectsUsingBlock:^(SimpleAlertButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
            make.width.mas_equalTo(kQADefaultContentViewWith * kPhoneWidthRatio);
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
    UIImageView *contentBGView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"作业上传保存失败断网的弹窗背景"]];
    
    UIImageView *tipIconView = [[UIImageView alloc]initWithImage:self.image];
    tipIconView.backgroundColor = [UIColor blueColor];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont boldSystemFontOfSize:21];
    titleLabel.textColor = [UIColor colorWithHexString:@"336600"];
    titleLabel.text = self.title;
    
    UILabel *describeLabel = [[UILabel alloc]init];
    describeLabel.textAlignment = NSTextAlignmentCenter;
    describeLabel.font = [UIFont systemFontOfSize:14];
    describeLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    describeLabel.text = self.describe;
    describeLabel.numberOfLines = 0;
    
    UIView *bottomView = [[UIView alloc]init];
    
    [defaultView addSubview:contentBGView];
    [defaultView addSubview:tipIconView];
    [defaultView addSubview:titleLabel];
    [defaultView addSubview:describeLabel];
    [defaultView  addSubview:bottomView];
    [contentBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(defaultView);
    }];
    [tipIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(contentBGView.mas_top).offset(self.image.size.height * 0.5);
        make.size.mas_equalTo(self.image.size);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tipIconView.mas_bottom).mas_offset(12 * kPhoneWidthRatio);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
    [describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).mas_offset(10.0f * kPhoneWidthRatio);
        make.left.right.equalTo(titleLabel);
    }];
    [self.alertButtonItems enumerateObjectsUsingBlock:^(SimpleAlertButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = obj.button;
        [bottomView addSubview:button];
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(describeLabel.mas_bottom).offset(20.0f * kPhoneWidthRatio);
        make.left.right.equalTo(defaultView);
        make.height.mas_equalTo(65 * kPhoneWidthRatio);
        make.bottom.equalTo(defaultView).offset(-15 * kPhoneWidthRatio);
    }];
    NSInteger buttonCount = bottomView.subviews.count;
    CGFloat buttonHeight = 50 * kPhoneWidthRatio;
    if (buttonCount == 1) {
        CGFloat buttonWith = 214 * kPhoneWidthRatio;
        [bottomView.subviews.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bottomView);
            make.centerY.equalTo(bottomView);
            make.size.mas_equalTo(CGSizeMake(buttonWith,buttonHeight));
        }];
    }
    if (buttonCount == 2) {
        CGFloat buttonWith = 135 * kPhoneWidthRatio;
        CGFloat margin = (CGFloat)(kQADefaultContentViewWith * kPhoneWidthRatio - buttonCount * buttonWith)/(buttonCount + 1);
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

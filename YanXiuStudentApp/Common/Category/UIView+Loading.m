//
//  UIView+Loading.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/4/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "UIView+Loading.h"
#import "YXLoadingView.h"
#import "YXToastView.h"
#import "YXTipsView.h"

static YXToastView *_toastView;
static YXTipsView *_tipsView;

@implementation UIView (Loading)

- (void)nyx_startLoading {
    [self endEditing:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [YXLoadingControl startLoadingWithSuperview:self];
}

- (void)nyx_stopLoading {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [YXLoadingControl stopLoadingWithSuperview:self];
}

- (void)nyx_showToast:(NSString *)text {
    if (![text yx_isValidString]) {
        return;
    }
    if (!_toastView) {
        _toastView = [[YXToastView alloc] init];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self addSubview:_toastView];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:_toastView];
    }
    [_toastView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _toastView.text = text;
    [_toastView show:YES];
    [_toastView hide:YES afterDelay:1.f];
}

- (void)nyx_showTipsWithTitle:(NSString *)title
                        text:(NSString *)text
                  detailText:(NSString *)detailText
{
    if (![title yx_isValidString] || ![text yx_isValidString]) {
        return;
    }
    if (!_tipsView) {
        _tipsView = [[YXTipsView alloc] init];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self addSubview:_tipsView];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:_tipsView];
    }
    [_tipsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _tipsView.title = title;
    _tipsView.text = text;
    _tipsView.detailText = detailText;
    [_tipsView show:YES];
    [_tipsView hide:YES afterDelay:1.f];
}
@end

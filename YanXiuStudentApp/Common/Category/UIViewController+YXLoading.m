//
//  UIViewController+YXLoading.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/14.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "UIViewController+YXLoading.h"
#import "YXToastView.h"
#import "YXTipsView.h"
#import "NSString+YXString.h"

static YXToastView *_toastView;
static YXTipsView *_tipsView;

@implementation UIViewController (YXLoading)

- (UIView *)yx_startLoading
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    return [YXLoadingControl startLoadingWithSuperview:self.view];
}

- (void)yx_stopLoading
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [YXLoadingControl stopLoadingWithSuperview:self.view];
}

- (void)yx_showToast:(NSString *)toast
{
    if (![toast yx_isValidString]) {
        return;
    }
    if (!_toastView) {
        _toastView = [[YXToastView alloc] init];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.view addSubview:_toastView];
    } else {
        [[UIApplication sharedApplication].keyWindow addSubview:_toastView];
    }
    [_toastView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _toastView.text = toast;
    [_toastView show:YES];
    [_toastView hide:YES afterDelay:1.f];
}

- (void)yx_showTipsWithTitle:(NSString *)title
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
        [self.view addSubview:_tipsView];
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

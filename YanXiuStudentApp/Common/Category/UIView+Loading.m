//
//  UIView+Loading.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/4/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "UIView+Loading.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIView (Loading)

- (void)nyx_startLoading {
    [self endEditing:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    if ([MBProgressHUD HUDForView:self]) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self animated:YES];
}

- (void)nyx_stopLoading {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)nyx_showToast:(NSString *)text {
    [MBProgressHUD hideAllHUDsForView:self animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1];
}

@end

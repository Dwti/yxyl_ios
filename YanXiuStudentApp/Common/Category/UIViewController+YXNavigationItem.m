//
//  UIViewController+YXNavigationItem.m
//  YXPublish
//
//  Created by ChenJianjun on 15/5/21.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "UIViewController+YXNavigationItem.h"
#import "YXBarButtonItemCustomView.h"

@implementation UIViewController (YXNavigationItem)

#pragma mark - 左侧返回按钮

- (void)yx_setupLeftBackBarButtonItem
{
    [self yx_setupLeftBackBarButtonItemWithTitle:nil];
}

- (void)yx_setupLeftBackBarButtonItemWithTitle:(NSString *)title
{
    YXBarButtonItemCustomView *customView = [self customViewWithTitle:title
                                                                image:[UIImage imageNamed:@"返回icon"]
                                                     highLightedImage:[UIImage imageNamed:@"返回icon-按下"]];
    [self setButton:customView.button sel:@selector(yx_leftBackButtonPressed:)];
    self.navigationItem.leftBarButtonItems = [self barButtonItemsWithCustomView:customView];
}

- (void)yx_leftBackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 左侧取消按钮

- (void)yx_setupLeftCancelBarButtonItem
{
    YXBarButtonItemCustomView *customView = [self customViewWithTitle:nil
                                                                image:[UIImage imageNamed:@"取消icon"]
                                                     highLightedImage:[UIImage imageNamed:@"取消icon-按下"]];
    [self setButton:customView.button sel:@selector(yx_leftCancelButtonPressed:)];
    self.navigationItem.leftBarButtonItems = [self barButtonItemsWithCustomView:customView];
}

- (void)yx_leftCancelButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 右侧按钮

- (UIButton *)yx_setupRightButtonItemWithTitle:(NSString *)title
                                         image:(UIImage *)image
                              highLightedImage:(UIImage *)highLightedImage
{
    YXBarButtonItemCustomView *customView = [self customViewWithTitle:title
                                                                image:image
                                                     highLightedImage:highLightedImage
                                                              isRight:YES];
    [self setButton:customView.button sel:@selector(yx_rightButtonPressed:)];
    self.navigationItem.rightBarButtonItems = [self barButtonItemsWithCustomView:customView];
    return customView.button;
}

- (void)yx_rightButtonPressed:(id)sender
{
    
}

#pragma mark -

- (YXBarButtonItemCustomView *)customViewWithTitle:(NSString *)title
                                             image:(UIImage *)image
                                  highLightedImage:(UIImage *)highLightedImage

{
    return [self customViewWithTitle:title
                               image:image
                    highLightedImage:highLightedImage
                             isRight:NO];
}

- (YXBarButtonItemCustomView *)customViewWithTitle:(NSString *)title
                                             image:(UIImage *)image
                                  highLightedImage:(UIImage *)highLightedImage
                                           isRight:(BOOL)isRight
{
    YXBarButtonItemCustomView *customView = [[YXBarButtonItemCustomView alloc] init];
    [customView setButtonTitle:title image:image highLightedImage:highLightedImage isRight:isRight];
    
    return customView;
}

- (void)setButton:(UIButton *)button sel:(SEL)sel
{
    [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
}

- (NSArray *)barButtonItemsWithCustomView:(UIView *)customView
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    return @[negativeSpacer, barButtonItem];
}

@end

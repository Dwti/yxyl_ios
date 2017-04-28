//
//  UIViewController+NavigationItem.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/4/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "UIViewController+NavigationItem.h"

@implementation UIViewController (NavigationItem)
- (void)nyx_setupLeftWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(ActionBlock)action{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightImageName];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, normalImage.size.width, normalImage.size.height)];
    [self nyx_adjustFrameForView:backButton];
    [backButton setImage:normalImage forState:UIControlStateNormal];
    [backButton setImage:highlightImage forState:UIControlStateHighlighted];
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        BLOCK_EXEC(action);
    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItems = @[[self nyx_negativeBarButtonItem],leftItem];
}

- (void)nyx_setupLeftWithCustomView:(UIView *)view{
    CGRect rect = view.bounds;
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self nyx_adjustFrameForView:containerView];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:view];
    view.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    self.navigationItem.leftBarButtonItems = @[[self nyx_negativeBarButtonItem],rightItem];
}

- (void)nyx_setupRightWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(ActionBlock)action{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightImageName];
    
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, normalImage.size.width, normalImage.size.height)];
    [self nyx_adjustFrameForView:rightButton];
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    [rightButton setImage:highlightImage forState:UIControlStateHighlighted];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        BLOCK_EXEC(action);
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItems = @[[self nyx_negativeBarButtonItem],rightItem];
}

- (void)nyx_setupRightWithTitle:(NSString *)title action:(ActionBlock)action{
    UIButton *b = [[UIButton alloc]init];
    [b setTitle:title forState:UIControlStateNormal];
    [b setTitleColor:[UIColor colorWithHexString:@"4691a6"] forState:UIControlStateNormal];
    b.titleLabel.font = [UIFont systemFontOfSize:14];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:b.titleLabel.font}];
    b.frame = CGRectMake(0, 0, ceilf(size.width), ceilf(size.height));
    [self nyx_adjustFrameForView:b];
    [[b rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        BLOCK_EXEC(action);
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:b];
    self.navigationItem.rightBarButtonItems = @[[self nyx_negativeBarButtonItem],rightItem];
}

- (void)nyx_setupRightWithCustomView:(UIView *)view{
    CGRect rect = view.bounds;
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self nyx_adjustFrameForView:containerView];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:view];
    view.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    self.navigationItem.rightBarButtonItems = @[[self nyx_negativeBarButtonItem],rightItem];
}

- (void)nyx_adjustFrameForView:(UIView *)view {
    view.width += 20;
    view.height += 20;
}

- (UIBarButtonItem *)nyx_negativeBarButtonItem{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -16;
    return negativeSpacer;
}

- (void)nyx_enableRightNavigationItem {
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.enabled = YES;
    }
}

- (void)nyx_disableRightNavigationItem {
    for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
        item.enabled = NO;
    }
}

@end

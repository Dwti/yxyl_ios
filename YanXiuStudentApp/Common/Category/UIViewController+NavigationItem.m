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
    [self nyx_setupLeftWithImage:[UIImage imageNamed:imageName] action:action];
}

- (void)nyx_setupLeftWithImage:(UIImage *)image action:(ActionBlock)action {
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [self nyx_adjustFrameForView:backButton];
    [backButton setImage:image forState:UIControlStateNormal];
    [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        BLOCK_EXEC(action);
    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:[self nyx_viewForItemView:backButton]];
    self.navigationItem.leftBarButtonItems = @[[self nyx_leftNegativeBarButtonItem],leftItem];
}

- (void)nyx_setupLeftWithCustomView:(UIView *)view{
    CGRect rect = view.bounds;
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self nyx_adjustFrameForView:containerView];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:view];
    view.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:[self nyx_viewForItemView:containerView]];
    self.navigationItem.leftBarButtonItems = @[[self nyx_leftNegativeBarButtonItem],rightItem];
}

- (void)nyx_setupRightWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName action:(ActionBlock)action{
    [self nyx_setupRightWithImage:[UIImage imageNamed:imageName] action:action];
}

- (void)nyx_setupRightWithImage:(UIImage *)image action:(ActionBlock)action{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [self nyx_adjustFrameForView:rightButton];
    [rightButton setImage:image forState:UIControlStateNormal];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        BLOCK_EXEC(action);
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:[self nyx_viewForItemView:rightButton]];
    self.navigationItem.rightBarButtonItems = @[[self nyx_rightNegativeBarButtonItem],rightItem];
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
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:[self nyx_viewForItemView:b]];
    self.navigationItem.rightBarButtonItems = @[[self nyx_rightNegativeBarButtonItem],rightItem];
}

- (void)nyx_setupRightWithCustomView:(UIView *)view{
    CGRect rect = view.bounds;
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    [self nyx_adjustFrameForView:containerView];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:view];
    view.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:[self nyx_viewForItemView:containerView]];
    self.navigationItem.rightBarButtonItems = @[[self nyx_rightNegativeBarButtonItem],rightItem];
}

- (void)nyx_adjustFrameForView:(UIView *)view {
    view.width += 20;
    view.height += 20;
}

- (UIView *)nyx_viewForItemView:(UIView *)itemView {
    CGRect rect = itemView.bounds;
    rect.size.height += 11;
    UIView *v = [[UIView alloc]initWithFrame:rect];
    [v addSubview:itemView];
    return v;
}

- (UIBarButtonItem *)nyx_leftNegativeBarButtonItem{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -14;
    return negativeSpacer;
}

- (UIBarButtonItem *)nyx_rightNegativeBarButtonItem{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -14;
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

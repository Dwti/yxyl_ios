//
//  BaseViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/1/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+YXImage.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *vcArray = self.navigationController.viewControllers;
    if (!isEmpty(vcArray)) {
        if (vcArray[0] != self) {
            WEAK_SELF
            [self nyx_setupLeftWithImage:[UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 26, 26)] action:^{
                STRONG_SELF
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self yx_stopLoading];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [MTA trackPageViewBegin:NSStringFromClass([self class])];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [MTA trackPageViewEnd:NSStringFromClass([self class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    NSLog(@"-----%@", [self class]);
    YXNavigationController *navi = (YXNavigationController *)self.navigationController;
    navi.theme = self.naviTheme;
}

#pragma mark - 相关的Util
+ (NSArray *)barButtonItemsWithButton:(UIButton *)button
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    return @[negativeSpacer, barButtonItem];
}

+ (void)update_v_image_title_forButton:(UIButton *)button
                             withWidth:(CGFloat)width
                             topMargin:(CGFloat)topMargin
               gapBetweenTitleAndImage:(CGFloat)gap
                          bottomMargin:(CGFloat)bottomMargin
{
    UIImage *icon = [button imageForState:UIControlStateNormal];
    CGSize iconSize = icon.size;
//    NSString *title = [button titleForState:UIControlStateNormal];
//    UIFont *titleFont = button.titleLabel.font;
//    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
    button.frame = CGRectMake(0, 0, width, CGFLOAT_MAX);
    [button setNeedsLayout]; [button layoutIfNeeded];
    button.frame = CGRectMake(0, 0, width, topMargin + iconSize.height + gap + button.titleLabel.frame.size.height + bottomMargin);
    
    CGFloat iconTop = topMargin;
    CGFloat iconBottom = floorf(button.frame.size.height - topMargin - iconSize.height);
    CGFloat iconLeft = 0.5 * (width - iconSize.width);
    CGFloat iconRight = 0.5 * (width - iconSize.width) - button.titleLabel.frame.size.width;
    button.imageEdgeInsets = UIEdgeInsetsMake(iconTop, iconLeft, iconBottom, iconRight);
    
    CGFloat titleTop = button.frame.size.height - bottomMargin - button.titleLabel.frame.size.height;
    CGFloat titleBottom = bottomMargin;
    CGFloat titleLeft = 0.5 * (width - button.titleLabel.frame.size.width) - iconSize.width;
    CGFloat titleRight = 0.5 * (width - button.titleLabel.frame.size.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(titleTop, titleLeft, titleBottom, titleRight);
}

+ (void)update_h_image_title_forButton:(UIButton *)button
                            withHeight:(CGFloat)height
                            leftMargin:(CGFloat)leftMargin
               gapBetweenTitleAndImage:(CGFloat)gap
                           rightMargin:(CGFloat)rightMargin
{
    UIImage *icon = [button imageForState:UIControlStateNormal];
    CGSize iconSize = icon.size;
//    NSString *title = [button titleForState:UIControlStateNormal];
//    UIFont *titleFont = button.titleLabel.font;
//    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
    button.frame = CGRectMake(0, 0, CGFLOAT_MAX, height);
    [button setNeedsLayout];
    [button layoutIfNeeded];
    button.frame = CGRectMake(0, 0, leftMargin + iconSize.width + gap + button.titleLabel.frame.size.width + rightMargin, height);
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, leftMargin, 0, button.frame.size.width - leftMargin - iconSize.width - button.titleLabel.frame.size.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, button.frame.size.width - leftMargin - iconSize.width - button.titleLabel.frame.size.width, 0, rightMargin);
}

+ (void)update_h_title_image_forButton:(UIButton *)button
                            withHeight:(CGFloat)height
                            leftMargin:(CGFloat)leftMargin
               gapBetweenTitleAndImage:(CGFloat)gap
                           rightMargin:(CGFloat)rightMargin
{
    UIImage *icon = [button imageForState:UIControlStateNormal];
    CGSize iconSize = icon.size;
    //    NSString *title = [button titleForState:UIControlStateNormal];
    //    UIFont *titleFont = button.titleLabel.font;
    //    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:titleFont}];
    button.frame = CGRectMake(0, 0, CGFLOAT_MAX, height);
    [button setNeedsLayout];
    [button layoutIfNeeded];
    button.frame = CGRectMake(0, 0, leftMargin + iconSize.width + gap + button.titleLabel.frame.size.width + rightMargin, height);
    
    button.imageEdgeInsets = UIEdgeInsetsMake(0, leftMargin + button.titleLabel.frame.size.width + gap, 0, rightMargin - button.titleLabel.frame.size.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, leftMargin - iconSize.width, 0, rightMargin + iconSize.width + gap);
}


#pragma mark -

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end

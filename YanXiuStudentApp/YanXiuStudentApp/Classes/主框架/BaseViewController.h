//
//  BaseViewController.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/1/15.
//  Copyright (c) 2015 yanxiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface BaseViewController : UIViewController
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, strong) UIButton *rightNaviButton;

#pragma mark -

// naviRightAction
- (void)setupRightWithImageNamed:(NSString *)imagename;
- (void)setupRightWithTitle:(NSString *)title;
- (void)naviRightAction;

#pragma mark - 相关的Util
+ (NSArray *)barButtonItemsWithButton:(UIButton *)button;

+ (void)update_v_image_title_forButton:(UIButton *)button
                             withWidth:(CGFloat)width
                             topMargin:(CGFloat)topMargin
               gapBetweenTitleAndImage:(CGFloat)gap
                          bottomMargin:(CGFloat)bottomMargin;

+ (void)update_h_image_title_forButton:(UIButton *)button
                            withHeight:(CGFloat)height
                            leftMargin:(CGFloat)leftMargin
               gapBetweenTitleAndImage:(CGFloat)gap
                           rightMargin:(CGFloat)rightMargin;

+ (void)update_h_title_image_forButton:(UIButton *)button
                            withHeight:(CGFloat)height
                            leftMargin:(CGFloat)leftMargin
               gapBetweenTitleAndImage:(CGFloat)gap
                           rightMargin:(CGFloat)rightMargin;
@end

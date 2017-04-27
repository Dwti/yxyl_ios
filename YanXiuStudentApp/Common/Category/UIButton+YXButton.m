//
//  UIButton+YXButton.m
//  YXKit
//
//  Created by ChenJianjun on 15/5/12.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "UIButton+YXButton.h"
#import "UIImage+YXImage.h"

@implementation UIButton (YXButton)

- (void)yx_exchangeTitleAndImagePosition
{
    CGSize imageSize = self.imageView.image.size;
    CGSize titleSize = self.titleLabel.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, 0, imageSize.width);
    self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width);
}

- (void)yx_setTitleColor:(UIColor *)color image:(UIImage *)image
{
    UIColor *translucentColor = [color colorWithAlphaComponent:0.5f]; // 半透明色值
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:translucentColor forState:UIControlStateHighlighted];
    [self setTitleColor:translucentColor forState:UIControlStateDisabled];
    if (image) {
        [self setImage:image forState:UIControlStateNormal];
        UIImage *translucentImage = [image yx_imageWithColor:translucentColor];
        [self setImage:translucentImage forState:UIControlStateHighlighted];
        [self setImage:translucentImage forState:UIControlStateDisabled];
    }
}

- (void)yx_setTitleColor:(UIColor *)color
{
    [self yx_setTitleColor:color image:nil];
}

- (void)yx_setUniformColor:(UIColor *)uniformColor
      highlightedTextColor:(UIColor *)highlightedTextColor
{
    [self setBackgroundImage:[UIImage yx_createImageWithColor:uniformColor] forState:UIControlStateHighlighted];
    [self setTitleColor:uniformColor forState:UIControlStateNormal];
    [self setTitleColor:(highlightedTextColor ?:[UIColor whiteColor]) forState:UIControlStateHighlighted];
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:5.f];
    [self.layer setBorderWidth:1.f];
    [self.layer setBorderColor:[uniformColor CGColor]];
}

@end

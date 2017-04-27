//
//  YXBarButtonItemCustomView.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/30.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXBarButtonItemCustomView.h"
#import "UIColor+YXColor.h"
#import "UIButton+YXButton.h"

@interface YXBarButtonItemCustomView ()

@property (nonatomic, strong) UIButton *button;

@end

@implementation YXBarButtonItemCustomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _button = [[UIButton alloc] init];
        [self addSubview:_button];
    }
    return self;
}

- (void)setButtonTitle:(NSString *)title
                 image:(UIImage *)image
      highLightedImage:(UIImage *)highLightedImage
               isRight:(BOOL)isRight
{
    if (image) {
        [self.button setImage:image forState:UIControlStateNormal];
        if (highLightedImage) {
            [self.button setImage:highLightedImage forState:UIControlStateHighlighted];
        } else {
            [self.button setImage:image forState:UIControlStateHighlighted];
        }
    } else {
        [self.button setBackgroundImage:[[UIImage imageNamed:@"保存按钮背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)] forState:UIControlStateNormal];
        [self.button setBackgroundImage:[[UIImage imageNamed:@"保存按钮背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 20, 10, 20)] forState:UIControlStateHighlighted];
    }
    
    CGFloat height = 30.f;
    CGFloat width = height;
    if (title) {
        [self.button setTitle:title forState:UIControlStateNormal];
        [self.button yx_setTitleColor:[UIColor yx_colorWithHexString:@"006666"]];
        self.button.titleLabel.layer.shadowColor = [UIColor yx_colorWithHexString:@"33ffff"].CGColor;
        self.button.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
        self.button.titleLabel.layer.shadowOpacity = 1;
        self.button.titleLabel.layer.shadowRadius = 0;
        self.button.titleLabel.font = [UIFont systemFontOfSize:13.f];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName: self.button.titleLabel.font}];
        if (image) {
            CGFloat insetWidth = 10.f;
            width = titleSize.width + image.size.width + 2 * insetWidth;
            if (isRight) {
                self.button.titleEdgeInsets = UIEdgeInsetsMake(0, -(image.size.width + insetWidth/2), 0, image.size.width + insetWidth/2);
                self.button.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width, 0, -titleSize.width);
            } else {
                self.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, insetWidth);
                self.button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, insetWidth + 5);
            }
        } else {
            width = (titleSize.width > 50.f) ? titleSize.width : 50.f;
        }
    }
    self.button.frame = CGRectMake(0, 0, width, height);
    self.frame = CGRectMake(0, 0, width, height + 3);
}

@end

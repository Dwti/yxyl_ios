//
//  CloneCategory.m
//  SanKeApp
//
//  Created by niuzhaowang on 2017/3/24.
//  Copyright © 2017年 niuzhaowang. All rights reserved.
//

#import "CloneCategory.h"

@implementation UIView (Clone)
- (id)clone {
    UIView *v = [UIView new];
    v.backgroundColor = self.backgroundColor;
    return v;
}
@end

@implementation UILabel (Clone)
- (id)clone {
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = self.backgroundColor;
    label.textColor = self.textColor;
    label.font = self.font;
    label.textAlignment = self.textAlignment;
    label.lineBreakMode = self.lineBreakMode;
    label.numberOfLines = self.numberOfLines;
    return label;
}
@end

@implementation UIButton (Clone)
- (id)clone {
    UIButton *b = [[UIButton alloc]init];
    b.backgroundColor = self.backgroundColor;
    b.titleEdgeInsets = self.titleEdgeInsets;
    b.imageEdgeInsets = self.imageEdgeInsets;
    b.titleLabel.font = self.titleLabel.font;
    [b setTitleColor:[self titleColorForState:UIControlStateNormal] forState:UIControlStateNormal];
    [b setTitleColor:[self titleColorForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [b setTitleColor:[self titleColorForState:UIControlStateSelected] forState:UIControlStateSelected];
    [b setImage:[self imageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [b setImage:[self imageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [b setImage:[self imageForState:UIControlStateSelected] forState:UIControlStateSelected];
    [b setBackgroundImage:[self backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [b setBackgroundImage:[self backgroundImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [b setBackgroundImage:[self backgroundImageForState:UIControlStateSelected] forState:UIControlStateSelected];
    return b;
}
@end


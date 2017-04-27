//
//  YXCommonLabel.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/12/17.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXCommonLabel.h"
#import "UIColor+YXColor.h"

@implementation YXCommonLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        self.textColor = [UIColor yx_colorWithHexString:@"805500"];
        self.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
        self.shadowOffset = CGSizeMake(0, 1);
    }
    return self;
}

@end

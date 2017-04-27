//
//  YXQADashLineView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXQADashLineView.h"

@implementation YXQADashLineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat lengths[] = {6,4};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
    CGContextSetLineWidth(context, 1);
    UIColor *color = self.color? self.color:[UIColor colorWithHexString:@"ccc4a3"];
    [color setStroke];
    CGContextStrokePath(context);
}


@end

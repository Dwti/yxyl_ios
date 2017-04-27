//
//  YXSmartDashLineView.m
//  abc
//
//  Created by niuzhaowang on 16/1/20.
//  Copyright © 2016年 niuzhaowang. All rights reserved.
//

#import "YXSmartDashLineView.h"

@implementation YXSmartDashLineView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.lineColor = [UIColor whiteColor];
        self.dashWidth = 6;
        self.gapWidth = 4;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, rect.size.height);
    [self.lineColor setStroke];
    CGFloat offset = 0.f;
    if (self.symmetrical) {
        NSInteger n = (rect.size.width-self.dashWidth)/(self.dashWidth+self.gapWidth);
        offset = (rect.size.width-n*(self.dashWidth+self.gapWidth)-self.dashWidth)/2;
    }
    CGContextMoveToPoint(context, 0, rect.size.height/2);
    CGContextAddLineToPoint(context, offset, rect.size.height/2);
    CGContextMoveToPoint(context, rect.size.width-offset, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height/2);
    CGContextStrokePath(context);
    
    CGFloat lengths[] = {self.dashWidth,self.gapWidth};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, offset, rect.size.height/2);
    CGContextAddLineToPoint(context, rect.size.width-offset, rect.size.height/2);
    CGContextStrokePath(context);
}


@end

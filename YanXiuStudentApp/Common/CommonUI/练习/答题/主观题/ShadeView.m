//
//  TestView.m
//  test
//
//  Created by 贾培军 on 2016/10/31.
//  Copyright © 2016年 DJ. All rights reserved.
//

#import "ShadeView.h"

@implementation ShadeView

- (void)setImage:(UIImage *)image{
    [self.layer setContents:(id)[image CGImage]];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;

    }
    return  self;
}

- (void)drawRect:(CGRect)rect {
    if (CGRectIsEmpty(self.contentFrame)) {
        return;
    }
    [[UIColor colorWithWhite:0.0f alpha:0.5f] setFill];//阴影效果 根据透明度来设计
    UIRectFill( rect );
    CGRect holeRectIntersection = CGRectIntersection(self.contentFrame, rect );
    [[UIColor clearColor] setFill];
    UIRectFill( holeRectIntersection );
}

@end

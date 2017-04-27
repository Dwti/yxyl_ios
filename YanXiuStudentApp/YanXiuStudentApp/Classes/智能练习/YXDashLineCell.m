
//
//  YXDashLineCell.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/2/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXDashLineCell.h"
@interface YXDashLineCell()
@property (nonatomic, assign) BOOL bLayoutDone;
@property (nonatomic, assign) CGFloat lastWidth;
@end

@implementation YXDashLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bLayoutDone = NO;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(context, rect);
    
    CGFloat lengths[] = {self.realWidth, self.dashWidth};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    if (!self.bHasShadow) {
        CGContextMoveToPoint(context, self.preferedGapToCellBounds, rect.size.height/2);
        CGContextAddLineToPoint(context, rect.size.width - self.preferedGapToCellBounds, rect.size.height/2);
        CGContextSetLineWidth(context, rect.size.height);
        [self.realColor setStroke];
        CGContextStrokePath(context);
    } else {
        CGContextMoveToPoint(context, self.preferedGapToCellBounds, rect.size.height/4);
        CGContextAddLineToPoint(context, rect.size.width-self.preferedGapToCellBounds, rect.size.height/4);
        CGContextSetLineWidth(context, rect.size.height/2);
        [self.realColor setStroke];
        CGContextStrokePath(context);
        
        CGContextMoveToPoint(context, self.preferedGapToCellBounds, rect.size.height*3/4);
        CGContextAddLineToPoint(context, rect.size.width-self.preferedGapToCellBounds, rect.size.height*3/4);
        CGContextSetLineWidth(context, rect.size.height/2);
        [self.shadowColor setStroke];
        CGContextStrokePath(context);
    }
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    if (ABS(self.lastWidth - self.contentView.frame.size.width) > 10) {
//        [super layoutSubviews];
//        self.bLayoutDone = YES;
//        
//        self.backgroundColor = [UIColor clearColor];
//        self.contentView.backgroundColor = [UIColor clearColor];
//        
//        for (UIView *v in self.contentView.subviews) {
//            [v removeFromSuperview];
//        }
//        
//        int count = (self.contentView.frame.size.width - 2 * self.preferedGapToCellBounds - self.realWidth) / (self.realWidth + self.dashWidth);
//        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, count * (self.realWidth + self.dashWidth) + self.realWidth, self.contentView.frame.size.height)];
//        containerView.backgroundColor = [UIColor clearColor];
//        containerView.center = CGPointMake(self.contentView.frame.size.width * 0.5, self.contentView.frame.size.height * 0.5);
//        [self.contentView addSubview:containerView];
//        containerView.clipsToBounds = YES;
//        
//        CGFloat x = 0;
//        for (int i = 0; i < count + 1; i++) {
//            x = (self.realWidth + self.dashWidth) * i;
//            
//            if (self.bHasShadow) {
//                CGFloat height = self.contentView.frame.size.height * 0.5;
//                UIView *vUp = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.realWidth, height)];
//                vUp.backgroundColor = self.realColor;
//                UIView *vShadow = [[UIView alloc] initWithFrame:CGRectMake(x, height, self.realWidth, height)];
//                vShadow.backgroundColor = self.shadowColor;
//                [containerView addSubview:vUp];
//                [containerView addSubview:vShadow];
//                
//            } else {
//                CGFloat height = self.contentView.frame.size.height;
//                UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x, 0, self.realWidth, height)];
//                v.backgroundColor = self.realColor;
//                [containerView addSubview:v];
//            }
//        }
//    }
//    self.lastWidth = self.contentView.frame.size.width;
//}

@end

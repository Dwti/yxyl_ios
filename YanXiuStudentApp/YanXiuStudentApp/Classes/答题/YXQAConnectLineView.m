//
//  YXQAConnectLineView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/10.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAConnectLineView.h"

@implementation YXQAConnectPosition

@end

@implementation YXQAConnectLineView

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
    for (QANumberGroupAnswer *answer in self.item.myAnswers) {
        NSMutableArray *pairArray = [NSMutableArray array];
        [answer.answers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSNumber *num = (NSNumber *)obj;
            if (num.boolValue) {
                [pairArray addObject:@(idx)];
            }
        }];
        if (pairArray.count == 2) {
            NSInteger first = ((NSNumber *)pairArray.firstObject).integerValue;
            NSInteger last = ((NSNumber *)pairArray.lastObject).integerValue;
            
            CGFloat leftY,rightY;
            NSInteger index = first;
            YXQAConnectPosition *p1 = self.positionArray[index];
            index = last-self.item.options.count/2;
            YXQAConnectPosition *p2 = self.positionArray[index];
            
            leftY = p1.position;
            rightY = p2.position;
            
            CGContextMoveToPoint(context, 0, leftY);
            CGContextAddLineToPoint(context, self.bounds.size.width, rightY);
            CGContextSetLineWidth(context, 2);
            UIColor *color = [self lineColorWithMyAnswer:answer];
            [color setStroke];
            CGContextStrokePath(context);
        }
    }
}

- (UIColor *)lineColorWithMyAnswer:(QANumberGroupAnswer *)myAnswer{
    if (self.showAnalysisAnswers) {
        NSInteger index = [self.item.myAnswers indexOfObject:myAnswer];
        QANumberGroupAnswer *correctAnswer = self.item.correctAnswers[index];
        if ([self isSameWithMyAnswer:myAnswer correctAnswer:correctAnswer]) {
            return [UIColor colorWithHexString:@"00cccc"];
        }else{
            return [UIColor colorWithHexString:@"ff99bb"];
        }
    }
    return [UIColor colorWithHexString:@"ccc4a3"];
}

- (BOOL)isSameWithMyAnswer:(QANumberGroupAnswer *)myAnswer correctAnswer:(QANumberGroupAnswer *)correctAnswer{
    __block BOOL isSame = YES;
    [myAnswer.answers enumerateObjectsUsingBlock:^(NSNumber *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *correct = correctAnswer.answers[idx];
        if (obj.boolValue != correct.boolValue) {
            isSame = NO;
            *stop = YES;
        }
    }];
    return isSame;
}

@end

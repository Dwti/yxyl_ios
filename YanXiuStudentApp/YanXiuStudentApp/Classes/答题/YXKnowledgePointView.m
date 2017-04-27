//
//  YXKnowledgePointView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/10/30.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXKnowledgePointView.h"

static const NSInteger kTagBase = 666;

@interface YXKnowledgePointView()
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, strong) NSMutableArray *widthArray;
@property (nonatomic, strong) NSMutableArray *buttonArray;
@end

@implementation YXKnowledgePointView

#pragma mark - Public
+ (CGFloat)heightWithPoints:(NSArray *)pointArray viewWidth:(CGFloat)width{
    __block CGFloat height = 0;
    __block CGFloat x = 0;
    [pointArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize size = [obj sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        CGFloat w = ceilf(size.width+20);
        if (w > width) {
            w = width;
        }
        CGFloat h = ceilf(size.height+20);
        if (height == 0) {
            height = h;
        }
        if ((x+w) > width) {
            x = 0;
            height += h + 15;
        }
        x += w + 15;
    }];
    return height;
}

#pragma mark -
- (void)setPointArray:(NSArray *)pointArray{
    _pointArray = pointArray;
    [self generateSizeWithPoints:pointArray];
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    self.buttonArray = [NSMutableArray array];
    [pointArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = [[UIButton alloc]init];
        [b setTitle:obj forState:UIControlStateNormal];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        b.titleLabel.font = [UIFont systemFontOfSize:13];
        UIImage *normalImage = [UIImage imageNamed:@"考点背景默认"];
        normalImage = [normalImage stretchableImageWithLeftCapWidth:normalImage.size.width/2 topCapHeight:normalImage.size.height/2];
        UIImage *highlightImage = [UIImage imageNamed:@"考点背景点击"];
        highlightImage = [highlightImage stretchableImageWithLeftCapWidth:highlightImage.size.width/2 topCapHeight:highlightImage.size.height/2];
        [b setBackgroundImage:normalImage forState:UIControlStateNormal];
        [b setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        b.tag = kTagBase + idx;
        [b addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:b];
        [self.buttonArray addObject:b];
    }];
    [self setNeedsLayout];
}

- (void)generateSizeWithPoints:(NSArray *)points{
    self.widthArray = [NSMutableArray array];
    for (NSString *p in points) {
        CGSize size = [p sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
        self.itemHeight = ceilf(size.height)+20;
        [self.widthArray addObject:@(ceilf(size.width)+20)];
    }
}

- (void)layoutSubviews{
    
    __block CGFloat x = 0;
    __block CGFloat y = 0;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = (UIButton *)obj;
        NSNumber *width = self.widthArray[idx];
        if (width.floatValue > self.frame.size.width) {
            width = @(self.frame.size.width);
        }
        if ((x+width.floatValue) > self.frame.size.width) {
            x = 0;
            y += self.itemHeight + 15;
        }
        [button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(x);
            make.top.mas_equalTo(y);
            make.height.mas_equalTo(self.itemHeight);
            make.width.mas_equalTo(width.floatValue);
        }];
        x += width.floatValue + 15;
    }];
    [super layoutSubviews];
}

#pragma Actions
- (void)buttonAction:(UIButton *)sender{
    NSInteger index = sender.tag - kTagBase;
    if (self.delegate && [self.delegate respondsToSelector:@selector(knowledgePointView:didSelectIndex:)]) {
        [self.delegate knowledgePointView:self didSelectIndex:index];
    }
}
@end

//
//  YXQAReportBirdRateView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/11.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXQAReportBirdRateView.h"

@interface YXQAReportBirdRateView()
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, assign) CGFloat gap;
@property (nonatomic, assign) CGFloat birdWidth;
@property (nonatomic, assign) NSInteger birdCount;
@end

@implementation YXQAReportBirdRateView

- (instancetype)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame birdCount:10];
}

- (instancetype)initWithFrame:(CGRect)frame birdCount:(NSInteger)count{
    if (self = [super initWithFrame:frame]) {
        self.birdCount = count;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.bottomView = [[UIView alloc]initWithFrame:self.bounds];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottomView];
    self.topView = [[UIView alloc]initWithFrame:self.bounds];
    self.topView.backgroundColor = [UIColor clearColor];
    self.topView.clipsToBounds = YES;
    [self addSubview:self.topView];
    UIImage *bottomImage = [UIImage imageNamed:@"底色小鸟"];
    UIImage *topImage = [UIImage imageNamed:@"粉色小鸟"];
    CGSize birdSize = bottomImage.size;
    CGFloat gap = floorf((self.bounds.size.width-birdSize.width*self.birdCount)/(self.birdCount-1));
    for (int i=0; i<self.birdCount; i++) {
        UIImageView *bv = [[UIImageView alloc]initWithImage:bottomImage];
        CGRect rect = CGRectMake((birdSize.width+gap)*i, (self.bounds.size.height-birdSize.height)/2, birdSize.width, birdSize.height);
        bv.frame = rect;
        [self.bottomView addSubview:bv];
        UIImageView *tv = [[UIImageView alloc]initWithImage:topImage];
        tv.frame = rect;
        [self.topView addSubview:tv];
    }
    self.gap = gap;
    self.birdWidth = birdSize.width;
}

- (void)setRate:(CGFloat)rate{
    _rate = rate;
    
    CGFloat birdRate = 1.0f/self.birdCount;
    NSInteger n = rate/birdRate;
    CGFloat width = n*(self.gap+self.birdWidth)+self.birdWidth*(rate-n*birdRate)*self.birdCount;
    CGRect rect = self.topView.frame;
    rect.size.width = width;
    self.topView.frame = rect;
}

@end

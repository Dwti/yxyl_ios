//
//  YXStarRateView.m
//  ImagePickerDemo
//
//  Created by wd on 15/9/24.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "YXStarRateView.h"

#define SELECT_STAR_IMAGE_NAME @"难度-评星-有星"
#define DEFAULT_STAR_IMAGE_NAME @"难度-评星-无星"
#define DEFALUT_STAR_COUNT 5
@interface YXStarRateView ()
@property (nonatomic, strong) UIView *  foregroundStarView;
@property (nonatomic, strong) UIView *  backgroundStarView;

@property (nonatomic, assign) NSInteger starsCount;
@property (nonatomic, assign) BOOL      canTap;
@end
@implementation YXStarRateView

- (instancetype)init {
    return [self initWithFrame:CGRectZero numberOfStars:DEFALUT_STAR_COUNT canTap:NO];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame numberOfStars:DEFALUT_STAR_COUNT canTap:NO];
}

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)count canTap:(BOOL)canTap {
    if (self = [super initWithFrame:frame]) {
        _starsCount = count;
        _canTap = canTap;
        [self setupViews];
    }
    return self;
}
- (void)setupViews
{
    _scorePercent = 1;//默认为1
    _canAnimation = NO;//默认为NO
    _allowIncompleteStar = NO;//默认为NO
    
    self.foregroundStarView = [self createStarViewWithImage:SELECT_STAR_IMAGE_NAME];
    self.backgroundStarView = [self createStarViewWithImage:DEFAULT_STAR_IMAGE_NAME];
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    if (_canTap) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];
    }
}
- (void)userTapRateView:(UITapGestureRecognizer *)gesture {
    CGPoint tapPoint = [gesture locationInView:self];
    CGFloat offset = tapPoint.x;
    CGFloat realStarScore = offset / (self.bounds.size.width / self.starsCount);
    CGFloat starScore = self.allowIncompleteStar ? realStarScore : ceilf(realStarScore);
    self.scorePercent = starScore / self.starsCount;
}
- (UIView *)createStarViewWithImage:(NSString *)imageName {
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    for (NSInteger i = 0; i < self.starsCount; i ++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * self.bounds.size.width / self.starsCount, 0, self.bounds.size.width / self.starsCount, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    @weakify(self);
    CGFloat animationTimeInterval = self.canAnimation ? 0.2 : 0;
    [UIView animateWithDuration:animationTimeInterval animations:^{
        @strongify(self);
        self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width * self.scorePercent, self.bounds.size.height);
    }];
}
- (void)setScorePercent:(CGFloat)scroePercent {
    if (_scorePercent == scroePercent) {
        return;
    }
    if (scroePercent < 0) {
        _scorePercent = 0;
    } else if (scroePercent > 1) {
        _scorePercent = 1;
    } else {
        _scorePercent = scroePercent;
    }
    
    [self setNeedsLayout];
}

- (void)updateWithDefaultImage:(UIImage *)defaultImage selectedImage:(UIImage *)selectedImage{
    for (UIImageView *v in self.backgroundStarView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            v.image = defaultImage;
        }
    }
    for (UIImageView *v in self.foregroundStarView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            v.image = selectedImage;
        }
    }
}

@end

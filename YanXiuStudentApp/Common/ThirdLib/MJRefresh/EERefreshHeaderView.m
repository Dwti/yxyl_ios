//
//  EERefreshHeaderView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/26.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "EERefreshHeaderView.h"

#define kMaxBottomHeight (SCREEN_HEIGHT>650? 45.f:30.f)

@interface EERefreshHeaderView()
@property (nonatomic, strong) MJRefreshHeaderView *mjHeaderView;
@property (nonatomic, strong) UIImageView *pencilImageView;
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UIImage *pullNormalImage;
@property (nonatomic, strong) UIImage *pullFlyImage;
@property (nonatomic, strong) UIImage *pullBubbleImage;
@property (nonatomic, assign) BOOL canShowPullImage;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
@property (nonatomic, assign) BOOL canShowBottom;
@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) CADisplayLink *displayLink;
@end

@implementation EERefreshHeaderView

- (instancetype)initWithMJHeaderView:(MJRefreshHeaderView *)headerView {
    if (self = [super initWithFrame:headerView.frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, -500, self.width, 500)];
        topView.backgroundColor = [UIColor whiteColor];
        [self addSubview:topView];
        self.mjHeaderView = headerView;
        self.mjHeaderView.frame = self.bounds;
        [self addSubview:self.mjHeaderView];
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.shapeLayer.fillColor = [UIColor colorWithHexString:@"edf0ee"].CGColor;
        self.shapeLayer.frame = CGRectMake(0, self.mjHeaderView.height, self.mjHeaderView.width, 0);
        [self.layer addSublayer:self.shapeLayer];
        self.pullNormalImage = [UIImage nyx_animatedGIFNamed:@"pull_normal"];
        self.pullFlyImage = [UIImage nyx_animatedGIFNamed:@"pull_fly"];
        self.pullBubbleImage = [UIImage nyx_animatedGIFNamed:@"pull_bubble"];
        self.pencilImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.pencilImageView.animationRepeatCount = 1;
        self.pencilImageView.animationDuration = self.pullFlyImage.duration;
        [self addSubview:self.pencilImageView];
        self.bubbleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 190, 120)];
        self.bubbleImageView.animationRepeatCount = 1;
        self.bubbleImageView.animationDuration = self.pullBubbleImage.duration;
        self.bubbleImageView.animationImages = self.pullBubbleImage.images;
        if (SCREEN_HEIGHT>650) {
            self.bubbleImageView.center = CGPointMake(headerView.width/2, headerView.height/2);
        }else {
            self.bubbleImageView.center = CGPointMake(headerView.width/2, headerView.height/2-15);
        }
        self.bubbleImageView.hidden = YES;
        [self.mjHeaderView addSubview:self.bubbleImageView];
        self.animationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        [self addSubview:self.animationView];
        self.canShowBottom = YES;
        self.mjHeaderView.imageView.hidden = YES;
        
        self.canShowPullImage = YES;
    }
    
    return self;
}

- (CGFloat)bottomHeight {
    return kMaxBottomHeight;
}

- (void)updateWithOffset:(CGFloat)offset{
    if (ABS(offset)==self.mjHeaderView.height && self.refreshing) {
        self.canShowBottom = NO;
    }else if (!self.refreshing) {
        self.canShowBottom = YES;
    }
    CGFloat bottom;
    if (!self.canShowBottom) {
        bottom = 0;
    }else {
        if (self.refreshing) {
            bottom = MIN(ABS(offset)-self.mjHeaderView.height, kMaxBottomHeight);
            bottom = MAX(bottom, 0);
        }else {
            bottom = MIN(ABS(offset), kMaxBottomHeight);
        }
    }
    
    CGFloat h = bottom+self.mjHeaderView.height;
    if (h!=self.height) {
        self.frame = CGRectMake(0, -h, self.width, h);
        self.shapeLayer.frame = CGRectMake(0, self.mjHeaderView.height, self.width, self.height-self.mjHeaderView.height);
        if (!self.refreshing) {
            [self updateShapeLayerWithControlPoint:CGPointMake(self.width/2, self.shapeLayer.frame.size.height)];
            self.animationView.center = CGPointMake(self.width/2, self.height);
        }
    }
    
    if (!self.canShowPullImage) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if (scrollView.isDragging) {
            self.canShowPullImage = YES;
        }
    }
    if (!self.refreshing && self.canShowPullImage) {
        NSInteger imageIndex = MIN(ABS(offset)/(kMaxBottomHeight+self.mjHeaderView.height), 0.99f)*self.pullNormalImage.images.count;
        self.pencilImageView.image = self.pullNormalImage.images[imageIndex];
        self.pencilImageView.center = CGPointMake(self.width/2, self.height-self.pencilImageView.height/2+30);
    }
}

- (void)updateShapeLayerWithControlPoint:(CGPoint)point {
    CGFloat w = self.width/2;
    CGFloat h = ABS(point.y);
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (h<=1) {
        [path moveToPoint:CGPointMake(0, point.y)];
        [path addLineToPoint:CGPointMake(self.width, point.y)];
        [path addLineToPoint:CGPointMake(self.width, 0)];
        [path addLineToPoint:CGPointMake(0, 0)];
    }else {
        CGFloat r = (pow(w, 2)+pow(h, 2))/(h*2);
        CGFloat radian = asin(w/r);
        if (point.y>0) {
            [path moveToPoint:CGPointMake(self.shapeLayer.frame.size.width, 0)];
            [path addArcWithCenter:CGPointMake(self.width/2, -(r-h)) radius:r startAngle:M_PI_2-radian endAngle:radian+M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake(0, h)];
            [path addLineToPoint:CGPointMake(self.shapeLayer.frame.size.width, h)];
        }else {
            [path moveToPoint:CGPointMake(0, 0)];
            [path addArcWithCenter:CGPointMake(self.width/2, (r-h)) radius:r startAngle:-M_PI_2-radian endAngle:-M_PI_2+radian clockwise:YES];
            [path addLineToPoint:CGPointMake(self.width, self.shapeLayer.frame.size.height)];
            [path addLineToPoint:CGPointMake(0, self.shapeLayer.frame.size.height)];
        }
    }
    [path closePath];
    self.shapeLayer.path = path.CGPath;
    
}

- (void)setRefreshing:(BOOL)refreshing {
    _refreshing = refreshing;
    if (refreshing) {
        [self showAnimation];
        self.canShowPullImage = NO;
    }
    if (!refreshing) {
        self.mjHeaderView.imageView.hidden = YES;
        self.pencilImageView.hidden = NO;
        [self.pencilImageView stopAnimating];
        self.pencilImageView.animationImages = nil;
        self.bubbleImageView.hidden = YES;
        [self.bubbleImageView stopAnimating];
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (void)showAnimation {
    self.animationFinished = NO;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    self.animationView.center = CGPointMake(self.width/2, self.height);
    [UIView animateWithDuration:.7f delay:0 usingSpringWithDamping:0.12 initialSpringVelocity:0 options:0 animations:^{
        self.animationView.center = CGPointMake(self.width/2, self.mjHeaderView.height);
    } completion:^(BOOL finished) {
        [self.displayLink invalidate];
        [self updateShapeLayerWithControlPoint:CGPointMake(self.width/2, 0)];
    }];
    
    self.pencilImageView.image = nil;
    self.pencilImageView.animationImages = self.pullFlyImage.images;
    [self.pencilImageView startAnimating];
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.pencilImageView.center = CGPointMake(self.self.pencilImageView.center.x, self.pencilImageView.center.y-500);
    } completion:^(BOOL finished) {
        
    }];
    [self performSelector:@selector(showBubble) withObject:nil afterDelay:0.1];
}

- (void)showBubble {
    self.bubbleImageView.hidden = NO;
    [self.bubbleImageView startAnimating];
    [self performSelector:@selector(showNormalLoading) withObject:nil afterDelay:self.pullBubbleImage.duration*0.7];
}

- (void)showNormalLoading {
    self.bubbleImageView.hidden = YES;
    self.mjHeaderView.imageView.hidden = NO;
    self.animationFinished = YES;
    BLOCK_EXEC(self.endBubbleBlock);
}

- (void)displayLinkAction {
    CALayer *layer = self.animationView.layer.presentationLayer;
    [self updateShapeLayerWithControlPoint:CGPointMake(layer.position.x, layer.position.y-self.mjHeaderView.height)];
}

@end

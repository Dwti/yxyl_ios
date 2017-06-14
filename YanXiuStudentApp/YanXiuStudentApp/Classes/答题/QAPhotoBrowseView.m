//
//  QAPhotoBrowseView.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoBrowseView.h"

static const CGFloat kMaxZoomScale = 1.5;

@interface QAPhotoBrowseView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL layoutComplete;
@end

@implementation QAPhotoBrowseView

- (void)leaveForeground {
    self.scrollView.zoomScale = 1.f;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    self.imageView = [[UIImageView alloc]init];
    self.imageView.userInteractionEnabled = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap)];
    tap.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:tap];
    self.doubleTapGesture = tap;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.layoutComplete) {
        self.scrollView.frame = self.bounds;
        self.imageView.frame = self.scrollView.bounds;
        UIImage *image = self.imageView.image;
        [self setupZoomScaleForImage:image];
        self.layoutComplete = YES;
    }
}

- (void)setupZoomScaleForImage:(UIImage *)image {
    if (image) {
        CGFloat oriScale = MIN(self.bounds.size.width/image.size.width, self.bounds.size.height/image.size.height);
        self.scrollView.maximumZoomScale = kMaxZoomScale;
        self.scrollView.minimumZoomScale = MIN(1/oriScale, 1);
    }
}

- (void)setImageAnswer:(QAImageAnswer *)imageAnswer {
    _imageAnswer = imageAnswer;
    self.imageView.image = imageAnswer.data;
    if (imageAnswer.url) {
        WEAK_SELF
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageAnswer.url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            STRONG_SELF
            if (self.layoutComplete) {
                [self setupZoomScaleForImage:image];
            }
        }];
    }
}

#pragma mark - Gestures
- (void)doubleTap {
    if (self.scrollView.zoomScale == self.scrollView.minimumZoomScale) {
        [self.scrollView setZoomScale:self.scrollView.maximumZoomScale animated:YES];
        CGFloat width = self.scrollView.bounds.size.width*self.scrollView.maximumZoomScale;
        CGFloat height = self.scrollView.bounds.size.height*self.scrollView.maximumZoomScale;
        CGFloat offsetX = (width-self.scrollView.bounds.size.width)/2;
        CGFloat offsetY = (height-self.scrollView.bounds.size.height)/2;
        [self.scrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:YES];
    }else {
        [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGSize size = self.scrollView.bounds.size;
    CGSize contentSize = self.scrollView.contentSize;
    CGFloat centerX = MAX(size.width, contentSize.width)/2;
    CGFloat centerY = MAX(size.height, contentSize.height)/2;
    
    self.imageView.center = CGPointMake(centerX, centerY);
}

@end

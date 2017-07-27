//
//  QAPhotoClipViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAPhotoClipViewController.h"
#import "QAPhotoClipBottomView.h"
#import "QAPhotoClipView.h"

static const CGFloat kBorderWidth = 22.f+23.f;

@interface QAPhotoClipViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) QAPhotoClipView *clipView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIImage *adjustedImage;
@end

@implementation QAPhotoClipViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)setupUI {
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, self.view.width-50, self.view.height-25-19-45)];
    self.adjustedImage = [self.oriImage nyx_aspectFillImageWithSize:self.imageView.frame.size];
    self.imageView.image = self.adjustedImage;
    [self.view addSubview:self.imageView];
    
    self.maskLayer = [CAShapeLayer layer];
    self.maskLayer.fillColor = [[UIColor blackColor]colorWithAlphaComponent:0.3].CGColor;
    self.maskLayer.frame = self.imageView.bounds;
    [self.imageView.layer addSublayer:self.maskLayer];
    
    self.clipView = [[QAPhotoClipView alloc]initWithFrame:CGRectInset(self.imageView.frame, -25, -25)];
    [self.view addSubview:self.clipView];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.clipView addGestureRecognizer:pan];
    
    QAPhotoClipBottomView *bottomView = [[QAPhotoClipBottomView alloc]initWithFrame:CGRectMake(0, self.view.height-45, self.view.width, 45)];
    WEAK_SELF
    [bottomView setExitBlock:^{
        STRONG_SELF
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [bottomView setConfirmBlock:^{
        STRONG_SELF
        CGRect rect = [self clippedImageRect];
        UIImage *image = [self imageForClippedRect:rect];
        BLOCK_EXEC(self.clippedBlock,image);
    }];
    [bottomView setResetBlock:^{
        self.clipView.frame = CGRectInset(self.imageView.frame, -25, -25);
        [self.clipView setNeedsDisplay];
        [self refreshMaskLayer];
    }];
    [self.view addSubview:bottomView];
}

- (CGRect)clippedImageRect {
    CGRect rect = [self.clipView convertRect:self.clipView.bounds toView:self.imageView];
    rect = CGRectInset(rect, 25, 25);
    return rect;
}

- (UIImage *)imageForClippedRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [self.adjustedImage drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.adjustedImage.size.width, self.adjustedImage.size.height)];
    UIImage *clippedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clippedImage;
}

- (void)refreshMaskLayer {
    CGRect rect = [self clippedImageRect];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.imageView.width, 0)];
    [path addLineToPoint:CGPointMake(self.imageView.width, self.imageView.height)];
    [path addLineToPoint:CGPointMake(0, self.imageView.height)];
    [path addLineToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:rect.origin];
    [path addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y+rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.origin.x+rect.size.width, rect.origin.y)];
    [path addLineToPoint:rect.origin];
    [path addLineToPoint:CGPointMake(0, 0)];
    self.maskLayer.path = path.CGPath;
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    CGRect dragRect = CGRectInset(gesture.view.bounds, kBorderWidth, kBorderWidth);
    CGPoint location = [gesture locationInView:gesture.view];
    CGPoint translation = [gesture translationInView:gesture.view];
    if (CGRectContainsPoint(dragRect, location)) {
        CGFloat x = gesture.view.x+translation.x;
        x = MAX(x, 0);
        x = MIN(x, self.view.width-gesture.view.width);
        CGFloat y = gesture.view.y+translation.y;
        y = MAX(y, 0);
        y = MIN(y, self.view.height-gesture.view.height-45+6);
        self.clipView.frame = CGRectMake(x, y, self.clipView.width, self.clipView.height);
    }else {
        if (location.x<=kBorderWidth && location.y>=kBorderWidth && location.y<=gesture.view.height-kBorderWidth*2) { // left
            CGFloat x = gesture.view.x+translation.x;
            x = [self adjuestedOriginXWithX:x];
            gesture.view.frame = CGRectMake(x, gesture.view.y, gesture.view.width-(x-gesture.view.x), gesture.view.height);
        }else if(location.x>=gesture.view.width-kBorderWidth && location.y>=kBorderWidth && location.y<=gesture.view.height-kBorderWidth*2) { // right
            CGFloat w = gesture.view.width+translation.x;
            w = [self adjuestedSizeWidthWithWidth:w];
            gesture.view.frame = CGRectMake(gesture.view.x, gesture.view.y, w, gesture.view.height);
        }else if(location.y<=kBorderWidth && location.x>=kBorderWidth && location.x<=gesture.view.width-kBorderWidth*2) { // top
            CGFloat y = gesture.view.y+translation.y;
            y = [self adjuestedOriginYWithY:y];
            gesture.view.frame = CGRectMake(gesture.view.x, y, gesture.view.width, gesture.view.height-(y-gesture.view.y));
        }else if(location.y>=gesture.view.height-kBorderWidth && location.x>=kBorderWidth && location.x<=gesture.view.width-kBorderWidth*2) { // bottom
            CGFloat h = gesture.view.height+translation.y;
            h = [self adjuestedSizeHeightWithHeight:h];
            gesture.view.frame = CGRectMake(gesture.view.x, gesture.view.y, gesture.view.width, h);
        }else if(location.y<=kBorderWidth && location.x<=kBorderWidth) { // topleft
            CGFloat x = gesture.view.x+translation.x;
            x = [self adjuestedOriginXWithX:x];
            CGFloat y = gesture.view.y+translation.y;
            y = [self adjuestedOriginYWithY:y];
            gesture.view.frame = CGRectMake(x, y, gesture.view.width-(x-gesture.view.x), gesture.view.height-(y-gesture.view.y));
        }else if(location.y<=kBorderWidth && location.x>=gesture.view.width-kBorderWidth) { // topright
            CGFloat w = gesture.view.width+translation.x;
            w = [self adjuestedSizeWidthWithWidth:w];
            CGFloat y = gesture.view.y+translation.y;
            y = [self adjuestedOriginYWithY:y];
            gesture.view.frame = CGRectMake(gesture.view.x, y, w, gesture.view.height-(y-gesture.view.y));
        }else if(location.x<=kBorderWidth && location.y>=gesture.view.height-kBorderWidth) { // bottomleft
            CGFloat x = gesture.view.x+translation.x;
            x = [self adjuestedOriginXWithX:x];
            CGFloat h = gesture.view.height+translation.y;
            h = [self adjuestedSizeHeightWithHeight:h];
            gesture.view.frame = CGRectMake(x, gesture.view.y, gesture.view.width-(x-gesture.view.x), h);
        }else if(location.y>=gesture.view.height-kBorderWidth && location.x>=gesture.view.width-kBorderWidth) { // bottomright
            CGFloat w = gesture.view.width+translation.x;
            w = [self adjuestedSizeWidthWithWidth:w];
            CGFloat h = gesture.view.height+translation.y;
            h = [self adjuestedSizeHeightWithHeight:h];
            gesture.view.frame = CGRectMake(gesture.view.x, gesture.view.y, w, h);
        }
        
        [gesture.view setNeedsDisplay];
    }
    [gesture setTranslation:CGPointZero inView:gesture.view];
    [self refreshMaskLayer];
}

- (CGFloat)adjuestedOriginXWithX:(CGFloat)oriX {
    CGFloat x = oriX;
    x = MAX(x, 0);
    x = MIN(x, self.clipView.x+self.clipView.width-kBorderWidth*2);
    return x;
}

- (CGFloat)adjuestedOriginYWithY:(CGFloat)oriY {
    CGFloat y = oriY;
    y = MAX(y, 0);
    y = MIN(y, self.clipView.y+self.clipView.height-kBorderWidth*2);
    return y;
}

- (CGFloat)adjuestedSizeWidthWithWidth:(CGFloat)oriW {
    CGFloat w = oriW;
    w = MAX(w, kBorderWidth*2);
    w = MIN(w, self.view.width-self.clipView.x);
    return w;
}

- (CGFloat)adjuestedSizeHeightWithHeight:(CGFloat)oriH {
    CGFloat h = oriH;
    h = MAX(h, kBorderWidth*2);
    h = MIN(h, self.view.height-self.clipView.y-45+6);
    return h;
}

@end

//
//  ScaleView.m
//  test
//
//  Created by 贾培军 on 2016/11/1.
//  Copyright © 2016年 DJ. All rights reserved.
//

#import "EditPictureView.h"
#import "ShadeView.h"
#import "ScaleView.h"
#import "UIImage+YXImage.h"
#import "PrefixHeader.pch"

float const radius = 10;
NSString *firstLoad = @"editPictureFirstLoad";

@interface EditPictureView()

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) ShadeView *shadeView;
@property (nonatomic, strong) ScaleView *scaleView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIView *pictureView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *tailorButton;
@property (nonatomic, strong) UIImage *image;

@end

@implementation EditPictureView

- (CGSize)getImageSizeWithImage:(UIImage *)image
{
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - 40 - 20;
    CGFloat imageWidth = self.image.size.width;
    CGFloat imageHeight = self.image.size.height;
    if (imageWidth < width && imageHeight < height) {
        return self.image.size;
    }else{
        CGFloat scale = imageWidth / width;
        if (imageHeight / height > scale) {
            scale = imageHeight / height;
        }
        width = imageWidth / scale;
        height = imageHeight / scale;
        return CGSizeMake(width, height);
    }
}

#pragma mark-
- (void)setupUI{

    self.pictureView = [UIView new];
    self.pictureView.contentMode = UIViewContentModeScaleAspectFit;
    self.pictureView.frame = [UIScreen mainScreen].bounds;
    self.pictureView.y = 20;
    [self.pictureView setH:self.pictureView.height - 40 - 20];
    self.pictureView.backgroundColor = [UIColor blackColor];
    [self.pictureView.layer setContents:(id)[self.image CGImage]];
    [self addSubview:self.pictureView];
    
    self.shadeView = [ShadeView new];
    self.shadeView.frame = self.frame;
    [self.pictureView addSubview:self.shadeView];
    
    self.image = [self.image scaleToSize:[self getImageSizeWithImage:self.image]];
    CGFloat imageWidth = self.image.size.width;
    CGFloat imageHeight = self.image.size.height;
    self.scaleView = [ScaleView new];
    self.scaleView.frame = CGRectMake((self.pictureView.width - imageWidth * 0.8) / 2, (self.pictureView.height - imageHeight * 0.8) / 2, imageWidth * 0.8, imageHeight * 0.8);
    UIPanGestureRecognizer *pan = [UIPanGestureRecognizer new];
    __block CGPoint start;
    __block CGFloat x;
    __block CGFloat y;
    CGFloat imageX = (self.pictureView.width - imageWidth) / 2;
    CGFloat imageY = (self.pictureView.height - imageHeight) / 2;
//    CGFloat imageY = (self.pictureView.height - imageHeight) / 2 + 20;
    WEAK_SELF
    [[pan rac_gestureSignal] subscribeNext:^(UIPanGestureRecognizer *recognizer) {
        STRONG_SELF
        if (recognizer.state ==  UIGestureRecognizerStateBegan) {
            x = self.scaleView.frame.origin.x;
            y = self.scaleView.frame.origin.y;
            start = [recognizer locationInView:self];
        }else if (recognizer.state == UIGestureRecognizerStateChanged || recognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint change = [recognizer locationInView:self];
            CGFloat realX = self.scaleView.x;
            CGFloat realY = self.scaleView.y;
            realX = x + change.x - start.x;
            realY = y + change.y - start.y;
            if (realX + self.scaleView.width > imageX + imageWidth){
                realX = imageX + imageWidth - self.scaleView.width;
            }
            if (realY + self.scaleView.height > imageY + imageHeight){
                realY = imageY + imageHeight - self.scaleView.height;
            }
            if (realX < imageX) {
                realX = imageX;
            }
            if (realY < imageY){
                realY = imageY;
            }
            self.scaleView.x = realX;
            self.scaleView.y = realY;
        }
        self.shadeView.contentFrame = self.scaleView.frame;
        [self.shadeView setNeedsDisplay];
    }];
    [self.scaleView addGestureRecognizer:pan];
    [self.pictureView addSubview:self.scaleView];
    self.shadeView.contentFrame = self.scaleView.frame;
    
    for (int i = 0; i < 4; i++) {
        UIView *view = [UIView new];
        view.tag = i;
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
        view.layer.cornerRadius = 10;
        view.layer.masksToBounds = YES;
        [self addSubview:view];
        UIPanGestureRecognizer *pan = [UIPanGestureRecognizer new];
        WEAK_SELF
        [[pan rac_gestureSignal] subscribeNext:^(UIPanGestureRecognizer *pan) {
            STRONG_SELF
            if (pan.state != UIGestureRecognizerStateEnded && pan.state != UIGestureRecognizerStateFailed) {
                //通过使用 locationInView 这个方法,来获取到手势的坐标
                CGPoint location = [pan locationInView:self];
                NSLog(@"%@", NSStringFromCGPoint(location));
                
                NSInteger index = pan.view.tag;
                CGFloat maxY = imageY + imageHeight;
                CGFloat maxX = imageX + imageWidth;
                location.x = location.x > maxX? maxX: location.x;
                location.y = location.y > maxY? maxY: location.y;
                location.x = location.x < imageX? imageX: location.x;
                location.y = location.y < imageY? imageY: location.y;
                if (index == 0) {
                    [self.scaleView setW:self.scaleView.width - location.x + self.scaleView.x];
                    [self.scaleView setH:self.scaleView.height - location.y + self.scaleView.y];
                    self.scaleView.x = location.x;
                    self.scaleView.y = location.y;
                }else if (index == 1) {
                    [self.scaleView setH:self.scaleView.height - location.y + self.scaleView.y];
                    self.scaleView.y = location.y < imageY? imageY: location.y;
                    [self.scaleView setW:location.x - self.scaleView.x];
                }else if (index == 2) {
                    [self.scaleView setW:self.scaleView.width - location.x + self.scaleView.x];
                    self.scaleView.x = location.x < imageX? imageX: location.x;
                    [self.scaleView setH:location.y - self.scaleView.y];
                }else if (index == 3) {
                    [self.scaleView setW:location.x - self.scaleView.x];
                    [self.scaleView setH:location.y - self.scaleView.y];
                }
                if (self.scaleView.width < 1) {
                    [self.scaleView setW:1];
                }
                if (self.scaleView.height < 1) {
                    [self.scaleView setH:1];
                }
                if (self.scaleView.maxY > imageY + imageHeight) {
                    self.scaleView.y = imageY + imageHeight - self.scaleView.height;
                }
                self.shadeView.contentFrame = self.scaleView.frame;
                [self.shadeView setNeedsDisplay];
            }
        }];
        [view addGestureRecognizer:pan];
        [_buttons addObject:view];
        
    }
    
    self.toolBar = [UIView new];
    self.toolBar.backgroundColor = [UIColor colorWithRGBHex:0x2f2f2f];
    [self addSubview:self.toolBar];
    
    self.cancelButton = [UIButton new];
    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithRGBHex:0x12b7f5] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        if (self.cancel) {
            self.cancel();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.toolBar addSubview:self.cancelButton];
    
    self.tailorButton = [UIButton new];
    [self.tailorButton setTitle:@"裁剪" forState:UIControlStateNormal];
    [self.tailorButton setTitleColor:[UIColor colorWithRGBHex:0x12b7f5] forState:UIControlStateNormal];
    self.tailorButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [[self.tailorButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        CGFloat y = (self.pictureView.size.height - self.image.size.height) / 2;
        CGFloat left = (self.pictureView.size.width - self.image.size.width) / 2;
        CGRect frame = self.scaleView.frame;
        frame.origin.y = frame.origin.y - y;
        frame.origin.x = frame.origin.x - left;
        
        UIImage *image = [self clipedImageWithOriginalImage:self.image clipedBounds:frame];
        if (self.editComplete) {
            self.editComplete(image);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.toolBar addSubview:self.tailorButton];
}

- (void)setupLayout{
    for (int i = 0; i < self.buttons.count; i++) {
        UIView *view = self.buttons[i];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset = radius * 2;
            if (i == 0) {
                make.centerX.mas_equalTo(self.scaleView.mas_left).offset = 1;
                make.centerY.mas_equalTo(self.scaleView.mas_top).offset = 1;
            }else if (i == 1){
                make.centerX.mas_equalTo(self.scaleView.mas_right).offset = -1;
                make.centerY.mas_equalTo(self.scaleView.mas_top).offset = 1;
            }else if (i == 2){
                make.centerX.mas_equalTo(self.scaleView.mas_left).offset = 1;
                make.centerY.mas_equalTo(self.scaleView.mas_bottom).offset = -1;
            }else if (i == 3){
                make.centerX.mas_equalTo(self.scaleView.mas_right).offset = -1;
                make.centerY.mas_equalTo(self.scaleView.mas_bottom).offset = -1;
            }
        }];
    }
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        //make.top.mas_equalTo(self.pictureView.mas_bottom);
        make.height.mas_equalTo(40);
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.bottom.left.offset = 0;
        //make.width.offset = self.cancelButton.intrinsicContentSize.width + 30;
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
    }];
    [self.tailorButton mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.bottom.right.offset = 0;
        //make.width.offset = self.tailorButton.intrinsicContentSize.width + 30;
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
}

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image{
    if ([super initWithFrame:frame]) {
        self.image = image;
        self.buttons = [NSMutableArray new];
        self.backgroundColor = [UIColor blackColor];
        [self setupUI];
        [self setupLayout];
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    for (UIView *view in self.buttons) {
        CGRect frame = view.frame;
        frame.origin.x -= radius;
        frame.size.width += radius * 2;
        frame.origin.y -= radius;
        frame.size.height += radius * 2;
        if (CGRectContainsPoint(frame, point)) {
            return view;
        }
    }
    return [super hitTest:point withEvent:event];
}

- (void)firstLoad{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:firstLoad]) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:@"矩形-3"];
        [imageView sizeToFit];
        imageView.centerX = self.scaleView.maxX;
        imageView.centerY = self.scaleView.maxY;
        [self addSubview:imageView];
        [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            imageView.center = self.scaleView.center;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLoad];
    }
}

#pragma mark - utils
- (UIImage *)clipedImageWithOriginalImage:(UIImage *)oriImage clipedBounds:(CGRect)bounds {
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    [oriImage drawInRect:CGRectMake(-bounds.origin.x, -bounds.origin.y, oriImage.size.width, oriImage.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

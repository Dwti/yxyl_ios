//
//  HeadImageClipViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "HeadImageClipViewController.h"
#import "QAPhotoClipBottomView.h"

@interface HeadImageClipViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *clipView;
@property (nonatomic, strong) UIImage *adjustedImage;
@end

@implementation HeadImageClipViewController

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
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(25, 25, self.view.width-50, self.view.height-25-19-45)];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.scrollView.height);
    CGFloat margin = (self.scrollView.height-self.scrollView.width)/2;
    self.scrollView.contentInset = UIEdgeInsetsMake(margin, 0, margin, 0);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.width, self.scrollView.height)];
    self.adjustedImage = [self.oriImage nyx_aspectFillImageWithSize:self.imageView.frame.size];
    self.imageView.image = self.adjustedImage;
    [self.scrollView addSubview:self.imageView];
    
    self.clipView = [[UIView alloc]initWithFrame:CGRectMake(self.scrollView.x, margin+25, self.scrollView.width, self.scrollView.width)];
    self.clipView.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    self.clipView.layer.borderWidth = 2;
    self.clipView.userInteractionEnabled = NO;
    [self.view addSubview:self.clipView];
    
    UIView *topMaskView = [[UIView alloc]initWithFrame:CGRectMake(self.clipView.x, 25, self.clipView.width, margin)];
    topMaskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    topMaskView.userInteractionEnabled = NO;
    [self.view addSubview:topMaskView];
    
    UIView *bottomMaskView = [[UIView alloc]initWithFrame:CGRectMake(self.clipView.x, CGRectGetMaxY(self.clipView.frame), self.clipView.width, margin)];
    bottomMaskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    bottomMaskView.userInteractionEnabled = NO;
    [self.view addSubview:bottomMaskView];
    
    QAPhotoClipBottomView *bottomView = [[QAPhotoClipBottomView alloc]initWithFrame:CGRectMake(0, self.view.height-45, self.view.width, 45)];
    bottomView.canReset = NO;
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
    [self.view addSubview:bottomView];
}

- (CGRect)clippedImageRect {
    CGRect rect = CGRectMake(0, (self.scrollView.height-self.clipView.height)/2+self.scrollView.contentOffset.y, self.clipView.width, self.clipView.height);
    return rect;
}

- (UIImage *)imageForClippedRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [self.adjustedImage drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, self.adjustedImage.size.width, self.adjustedImage.size.height)];
    UIImage *clippedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return clippedImage;
}

@end

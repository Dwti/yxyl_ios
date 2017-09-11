//
//  YXTabBarController.m
//  CustomTab
//
//  Created by niuzhaowang on 15/11/30.
//  Copyright © 2015年 niuzhaowang. All rights reserved.
//

#import "YXTabBarController.h"
#import "YXRedManager.h"
#import <UIButton+WebCache.h>
#import "AudioManager.h"

@interface YXTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL setupComplete;
@property (nonatomic, strong) UIButton *mineButton;
@end

@implementation YXTabBarController

@dynamic practiseNumber;
@dynamic assignmentNumber;
@dynamic myNumber;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUpdateHeadImgSuccessNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        [self refreshMineButton];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.setupComplete) {
        [self setupThreeButtons];
        self.setupComplete = YES;
    }
}

- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 65;
    tabFrame.origin.y = self.view.frame.size.height - 65;
    self.tabBar.frame = tabFrame;
    self.tabBar.shadowImage = [UIImage imageWithColor:[UIColor whiteColor]];
    self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    for (UIButton *b in self.tabButtons) {
        b.selected = NO;
    }
    UIButton *b = self.tabButtons[selectedIndex];
    b.selected = YES;
}

#pragma mark - UITabBarControllerDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    for (UIButton *b in self.tabButtons) {
        b.selected = NO;
    }
    UIButton *b = self.tabButtons[index];
    b.selected = YES;
    [UIView animateKeyframesWithDuration:0.08 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.04 animations:^{
            b.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
        [UIView addKeyframeWithRelativeStartTime:0.04 relativeDuration:0.04 animations:^{
            b.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
    
    //播放音效
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"tab 栏" ofType:@"wav"];
    [[AudioManager sharedInstance]playSoundWithUrl:[NSURL fileURLWithPath:filePath]];
}

#pragma mark - Hard Code 底部三个Button
- (void)setupThreeButtons {
    UIButton *b1 = [self bottemButtonWithTitle:@"作业"];
    UIButton *b2 = [self bottemButtonWithTitle:@"练习"];
    UIButton *b3 = [self bottemButtonWithTitle:@"我的"];
    self.mineButton = b3;
    [self refreshMineButton];
    self.tabButtons = @[ b1, b2, b3 ];
    
    CGRect rect = self.tabBar.bounds;
    rect.size.height = 65;
    UIView *bgView = [[UIView alloc]initWithFrame:rect];
    bgView.clipsToBounds = NO;
    bgView.userInteractionEnabled = NO;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar addSubview:bgView];
    
    for (int i = 0; i < 3; i++) {
        UIButton *b = self.tabButtons[i];
        b.userInteractionEnabled = NO;
        b.frame = CGRectMake(b.width*i, 0, b.width, b.height);
        b.selected = i == self.selectedIndex? YES:NO;
        
        [bgView addSubview:b];
    }
}

- (UIButton *)bottemButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"336600"] forState:UIControlStateSelected];
    
    UIImage *iconNormal = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon正常态",title]];
    UIImage *iconSelected = [UIImage imageNamed:[NSString stringWithFormat:@"%@icon选择态",title]];
    
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:iconNormal forState:UIControlStateNormal];
    [btn setImage:iconSelected forState:UIControlStateSelected];
    
    [btn sizeToFit];
    CGSize imageSize = btn.imageView.frame.size;
    CGSize titleSize = btn.titleLabel.frame.size;
    btn.imageEdgeInsets = UIEdgeInsetsMake(-titleSize.height/2+2, titleSize.width/2, titleSize.height/2-2, -titleSize.width/2);
    btn.titleEdgeInsets = UIEdgeInsetsMake(imageSize.height/2+2, -imageSize.width/2, -imageSize.height/2-2, imageSize.width/2);
    
    
    CGFloat width = floorf((self.tabBar.frame.size.width) / 3);
    btn.frame = CGRectMake(0, 0, width, 65);
    
    return btn;
}

- (void)refreshMineButton {
    NSURL *headUrl = [NSURL URLWithString:[YXUserManager sharedManager].userModel.head];
    UIImage *defaultImage = [self.mineButton imageForState:UIControlStateNormal];
    WEAK_SELF
    [self.mineButton sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        STRONG_SELF
        if (image) {
            UIImage *scaledImage = [self scaledHeadImage:image];
            [self.mineButton setImage:scaledImage forState:UIControlStateSelected];
            UIImage *grayImage = [scaledImage nyx_grayImage];
            UIImage *scaledGrayImage = [self scaledHeadImage:grayImage];
            [self.mineButton setImage:[scaledGrayImage nyx_imageWithAlpha:1.0] forState:UIControlStateNormal];
        }
    }];
}

- (UIImage *)scaledHeadImage:(UIImage *)image {
    CGSize scaledSize = [image nyx_aspectFillSizeWithSize:CGSizeMake(35, 35)];
    CGFloat x = (35-scaledSize.width)/2;
    CGFloat y = (35-scaledSize.height)/2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 35), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(1, 1, 33, 33));
    CGContextClip(context);
    [image drawInRect:CGRectMake(x, y, scaledSize.width, scaledSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end

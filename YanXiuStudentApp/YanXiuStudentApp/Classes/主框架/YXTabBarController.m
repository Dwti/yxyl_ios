//
//  YXTabBarController.m
//  CustomTab
//
//  Created by niuzhaowang on 15/11/30.
//  Copyright © 2015年 niuzhaowang. All rights reserved.
//

#import "YXTabBarController.h"
#import "YXHotNumberLabel.h"
#import "YXRedManager.h"
#import <UIButton+WebCache.h>

@interface YXTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL setupComplete;
@property (nonatomic, strong) NSArray *numberLabels;
@property (nonatomic, strong) UIButton *mineButton;
@end

@implementation YXTabBarController

@dynamic practiseNumber;
@dynamic assignmentNumber;
@dynamic myNumber;

#pragma mark- Get
- (NSArray *)numberLabels
{
    if (!_numberLabels) {
        NSMutableArray *numberLabels = [NSMutableArray new];
        for (int i = 0; i < 3; i++) {
            id label = [YXHotNumberLabel new];
            [numberLabels addObject:label];
        }
        _numberLabels = numberLabels;
    }
    return _numberLabels;
}

- (NSString *)practiseNumber
{
    return [self.numberLabels[1] text];
}

- (NSString *)assignmentNumber
{
    return [self.numberLabels[0] text];
}

- (NSString *)myNumber
{
    return [self.numberLabels.lastObject text];
}

#pragma mark- Set
- (void)setPractiseNumber:(NSString *)practiseNumber
{
    [self.numberLabels[1] setText:practiseNumber];
}

- (void)setAssignmentNumber:(NSString *)assignmentNumber
{
    [self.numberLabels[0] setText:assignmentNumber];
}

- (void)setMyNumber:(NSString *)myNumber
{
    [self.numberLabels.lastObject setText:myNumber];
}

#pragma mark- NSNotification
- (void)redChanged:(id)sender
{
    self.assignmentNumber = [sender object];
}

#pragma mark-
- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(redChanged:)
                                                     name:YXRedNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:YXRedNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
    [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
        b.transform = CGAffineTransformMakeScale(1.2, 1.2);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration: 0.7 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:0 animations:^{
            b.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:nil];
    }];
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
    for (int i = 0; i < 3; i++) {
        UIButton *b = self.tabButtons[i];
        
        UILabel *label = self.numberLabels[i];
        [bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(b.mas_top).offset = 6;
            make.right.mas_equalTo(b.mas_centerX).offset = 25;
        }];
    }
}

- (UIButton *)bottemButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    
    [btn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"336600"] forState:UIControlStateSelected];

    UIImage *iconNormal = [UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 35, 35)];
    
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:iconNormal forState:UIControlStateNormal];

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
    UIImage *defaultImage = [UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 35, 35)];
    WEAK_SELF
    [self.mineButton sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:defaultImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        STRONG_SELF
        if (image) {
            [self.mineButton setImage:[self scaledHeadImage:image] forState:UIControlStateNormal];
        }
    }];
}

- (UIImage *)scaledHeadImage:(UIImage *)image {
    CGSize scaledSize = [image nyx_aspectFillSizeWithSize:CGSizeMake(35, 35)];
    CGFloat x = (35-scaledSize.width)/2;
    CGFloat y = (35-scaledSize.height)/2;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(35, 35), NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, CGRectMake(0, 0, 35, 35));
    CGContextClip(context);
    [image drawInRect:CGRectMake(x, y, scaledSize.width, scaledSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end

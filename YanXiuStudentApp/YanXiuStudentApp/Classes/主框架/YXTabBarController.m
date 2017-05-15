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

@interface YXTabBarController ()<UITabBarControllerDelegate>
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) BOOL setupComplete;
@property (nonatomic, strong) NSArray *numberLabels;
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
    return [self.numberLabels.firstObject text];
}

- (NSString *)assignmentNumber
{
    return [self.numberLabels[1] text];
}

- (NSString *)myNumber
{
    return [self.numberLabels.lastObject text];
}

#pragma mark- Set
- (void)setPractiseNumber:(NSString *)practiseNumber
{
    [self.numberLabels.firstObject setText:practiseNumber];
}

- (void)setAssignmentNumber:(NSString *)assignmentNumber
{
    [self.numberLabels[1] setText:assignmentNumber];
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.setupComplete) {
        [self setupThreeButtons];
        self.setupComplete = YES;
    }
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        [self setupThreeButtons];
//    });
    //[self setupCustomTabBar];
}

- (void)viewWillLayoutSubviews{
    CGRect tabFrame = self.tabBar.frame; //self.TabBar is IBOutlet of your TabBar
    tabFrame.size.height = 65;
    tabFrame.origin.y = self.view.frame.size.height - 65;
    self.tabBar.frame = tabFrame;
}

- (void)setupCustomTabBar{
    self.bgView = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    self.bgView.userInteractionEnabled = NO;
    [self.tabBar addSubview:self.bgView];
    
    UIView *bgUpperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.bounds.size.width, 3)];
    bgUpperView.backgroundColor = [UIColor colorWithHexString:@"009999"];
    [self.tabBar addSubview:bgUpperView];
    
    NSInteger count = self.tabButtons.count;
    CGFloat gap = 10;
    CGFloat w = (self.bgView.frame.size.width-gap*(count+1))/count;
    CGFloat h = 30;
    __block CGFloat x = gap;
    CGFloat y = (self.bgView.frame.size.height-h)/2;
    [self.tabButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *b = (UIButton *)obj;
        b.userInteractionEnabled = NO;
        b.frame = CGRectMake(x, y, w, h);
        b.selected = idx==self.selectedIndex? YES:NO;
        [self.bgView addSubview:b];
        x += w + gap;
    }];
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
}

static const CGFloat kBottomButtonGap = 5;
#pragma mark - Hard Code 底部三个Button
- (void)setupThreeButtons {
    UIButton *b1 = [self bottemButtonWithTitle:@"练习"];
    UIButton *b2 = [self bottemButtonWithTitle:@"作业"];
    UIButton *b3 = [self bottemButtonWithTitle:@"我的"];
    self.tabButtons = @[ b1, b2, b3 ];
    
    UIView *bgView = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    bgView.clipsToBounds = NO;
    bgView.userInteractionEnabled = NO;
    bgView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    [self.tabBar addSubview:bgView];
    UIView *bgUpperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tabBar.bounds.size.width, 3)];
    bgUpperView.backgroundColor = [UIColor colorWithHexString:@"009999"];
    [bgView addSubview:bgUpperView];
    
    for (int i = 0; i < 3; i++) {
        UIButton *b = self.tabButtons[i];
        b.userInteractionEnabled = NO;
        b.frame = CGRectMake((kBottomButtonGap + b.frame.size.width) * i + kBottomButtonGap, 6, b.frame.size.width, 40);
        b.selected = i == self.selectedIndex? YES:NO;
        
        [bgView addSubview:b];
    }
    for (int i = 0; i < 3; i++) {
        UIButton *b = self.tabButtons[i];
        
        UILabel *label = self.numberLabels[i];
        [bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(b.mas_top).offset = 3;
            make.right.mas_equalTo(b.mas_right).offset = -5;
        }];
    }
}

- (UIButton *)bottemButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [btn setTitleColor:[UIColor colorWithHexString:@"006666"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateSelected];

//    btn.titleLabel.layer.shadowColor = []
//    btn.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
//    btn.titleLabel.layer.shadowOpacity = 1;
//    btn.titleLabel.layer.shadowRadius = 1;

    UIImage *bgNormal = [[UIImage imageNamed:@"tap栏按钮-未激活"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 40)];
    UIImage *bgSelected = [[UIImage imageNamed:@"tap栏按钮-激活"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 40, 0, 40)];
    [btn setBackgroundImage:bgNormal forState:UIControlStateNormal];
    [btn setBackgroundImage:bgSelected forState:UIControlStateSelected];
    
    
    UIImage *iconNormal = [UIImage imageNamed:[title stringByAppendingString:@"_未选"]];
    UIImage *iconSelected = [UIImage imageNamed:[title stringByAppendingString:@"_选中"]];
    
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:iconNormal forState:UIControlStateNormal];
    [btn setImage:iconSelected forState:UIControlStateSelected];
    
    if ([UIScreen mainScreen].bounds.size.width > 320) {
        [BaseViewController update_h_image_title_forButton:btn
                                                withHeight:40
                                                leftMargin:18
                                   gapBetweenTitleAndImage:8
                                               rightMargin:22];
    } else {
        [BaseViewController update_h_image_title_forButton:btn
                                                withHeight:40
                                                leftMargin:10
                                   gapBetweenTitleAndImage:6
                                               rightMargin:10];
    }
    
    
    CGFloat width = floorf((self.tabBar.frame.size.width - 4 * kBottomButtonGap) / 3);
    btn.frame = CGRectMake(0, 0, width, 44);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    return btn;
}

@end

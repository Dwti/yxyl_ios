//
//  YXBaseViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXBaseViewController_Pad.h"

@interface YXBaseViewController_Pad ()

@end

@implementation YXBaseViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSArray *vcArray = self.navigationController.viewControllers;
    if (!isEmpty(vcArray)) {
        if (vcArray[0] != self) {
            [self setupLeftBack];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@", self.class);
}

#pragma mark - Navi Left


- (void)setupLeftBack{
    [self setupLeftWithImageNamed:@"返回icon" highlightImageNamed:@"返回icon-按下"];
}

- (void)setupLeftWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightImageName];
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, normalImage.size.width+20, normalImage.size.height+20)];
    [backButton setImage:normalImage forState:UIControlStateNormal];
    [backButton setImage:highlightImage forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(naviLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItems = @[[self negativeBarButtonItem],leftItem];
}

- (void)naviLeftAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navi Right
- (void)setupRightWithImageNamed:(NSString *)imageName highlightImageNamed:(NSString *)highlightImageName{
    UIImage *normalImage = [UIImage imageNamed:imageName];
    UIImage *highlightImage = [UIImage imageNamed:highlightImageName];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, normalImage.size.width+20, normalImage.size.height+20)];
    [rightButton setImage:normalImage forState:UIControlStateNormal];
    [rightButton setImage:highlightImage forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(naviRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItems = @[[self negativeBarButtonItem],rightItem];
}

- (void)naviRightAction{
    
}

- (void)setupRightWithCustomView:(UIView *)view{
    CGRect rect = view.bounds;
    UIView *containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width+20, rect.size.height+20)];
    containerView.backgroundColor = [UIColor clearColor];
    [containerView addSubview:view];
    view.center = CGPointMake(containerView.bounds.size.width/2, containerView.bounds.size.height/2);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:containerView];
    
    self.navigationItem.rightBarButtonItems = @[[self negativeBarButtonItem],rightItem];
}

#pragma mark - Negative BarButtonItem
- (UIBarButtonItem *)negativeBarButtonItem{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -11;
    return negativeSpacer;
}

#pragma mark - 
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)startLoading {
    [self yx_startLoading];
}

- (void)stopLoading {
    [self yx_stopLoading];
}

@end

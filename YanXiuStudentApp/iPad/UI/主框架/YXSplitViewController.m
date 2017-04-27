//
//  YXSplitViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/19.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSplitViewController.h"
#import "YXExerciseHistoryViewController_Pad.h"
#import "YXMyMistakeViewController_Pad.h"
#import "YXMyFavorViewController_Pad.h"
#import "UIResponder+FirstResponder.h"

@implementation UIViewController (YXSplitViewController)

- (YXSplitViewController *)yxSplitViewController{
    for (UIResponder *next = [self nextResponder]; next; next = [next nextResponder]) {
        if ([next isKindOfClass:[YXSplitViewController class]]) {
            return (YXSplitViewController *)next;
        }
    }
    return nil;
}

@end

@interface YXSplitViewController ()
@property (nonatomic, strong) UIViewController *leftVC;
@property (nonatomic, strong) NSArray *rightVCArray;
@property (nonatomic, strong) UIViewController *currentRightVC;

// 用于设置分割
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, strong) UIView *naviRightBarView;
@property (nonatomic, strong) UIImageView *naviSeperatorView;
@end

@implementation YXSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSeperatorUI];
}

- (void)setupSeperatorUI{
    self.shadowView = [[UIView alloc]init];
    self.shadowView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.2];

    self.naviRightBarView = [[UIView alloc]init];
//    self.naviRightBarView.backgroundColor = [UIColor blueColor];
    
    self.naviSeperatorView = [[UIImageView alloc]init];
    self.naviSeperatorView.image = [UIImage imageNamed:@"title栏分割线"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setupWithLeftVC:(UIViewController *)leftVC rightVCArray:(NSArray *)vcArray{
    self.leftVC = leftVC;
    self.rightVCArray = vcArray;
    [self.view addSubview:leftVC.view];
    [leftVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(210);
    }];
    [self setupRightVCWithIndex:1];
}

- (void)setupRightVCWithIndex:(NSInteger)index{
//    [self.currentRightVC beginAppearanceTransition:NO animated:NO];
//    [self.currentRightVC willMoveToParentViewController:nil];
    [self.currentRightVC.view removeFromSuperview];
//    [self.currentRightVC removeFromParentViewController];
//    [self.currentRightVC didMoveToParentViewController:nil];
//    [self.currentRightVC endAppearanceTransition];
    
    
    if (index < self.rightVCArray.count) {
        UIViewController *vc = self.rightVCArray[index];
//        [vc beginAppearanceTransition:YES animated:NO];
//        [vc willMoveToParentViewController:self];
//        [self addChildViewController:vc];
        [self.view addSubview:vc.view];
//        [vc didMoveToParentViewController:self];
//        [vc endAppearanceTransition];
        self.currentRightVC = vc;
        
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.leftVC.view.mas_right);
        }];
        
        
        id entranceVC = vc;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            entranceVC = ((UINavigationController *)vc).viewControllers.firstObject;
        }
        if ([entranceVC respondsToSelector:@selector(reloadUI)]) {
            [entranceVC performSelector:@selector(reloadUI)];
        }
        [self setupSeperatorStyleForVC:vc];
        [[UIResponder currentFirstResponder] resignFirstResponder];
    }
}

#pragma mark - 分割样式
- (void)setupSeperatorStyleForVC:(UIViewController *)vc{
    BOOL hasNavi = YES;
    if (![vc isKindOfClass:[UINavigationController class]]) {
        hasNavi = NO;
    }else{
        UINavigationController *navi = (UINavigationController *)vc;
        if (navi.navigationBarHidden) {
            hasNavi = NO;
        }
    }
    
    if (hasNavi) {
        [self.view addSubview:self.shadowView];
        [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftVC.view.mas_right);
            make.top.mas_equalTo(64);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(3);
        }];
        [self.view addSubview:self.naviSeperatorView];
        [self.naviSeperatorView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftVC.view.mas_right).mas_offset(-3);
            make.top.mas_equalTo(15);
            make.width.mas_equalTo(4);
            make.height.mas_equalTo(45);
        }];
        [self.naviRightBarView removeFromSuperview];
    }else{
        [self.view addSubview:self.shadowView];
        [self.shadowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftVC.view.mas_right);
            make.top.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo(3);
        }];
        [self.view addSubview:self.naviRightBarView];
        [self.naviRightBarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.leftVC.view.mas_right).mas_offset(-3);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(3);
            make.height.mas_equalTo(60);
        }];
        [self.naviSeperatorView removeFromSuperview];
    }
}

#pragma mark - 侧边的隐藏与显示
- (void)hideLeft{
    [UIView animateWithDuration:0.3 animations:^{
        [self.leftVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.right.mas_equalTo(self.view.mas_left);
            make.width.mas_equalTo(210);
        }];
        [self.currentRightVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.shadowView.hidden = YES;
        self.naviSeperatorView.hidden = YES;
        self.naviRightBarView.hidden = YES;
    }];
}

- (void)showLeft{
    self.shadowView.hidden = NO;
    self.naviSeperatorView.hidden = NO;
    self.naviRightBarView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        [self.leftVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(210);
        }];
        [self.currentRightVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.mas_equalTo(0);
            make.left.mas_equalTo(self.leftVC.view.mas_right);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - YXSideMenuPadDelegate
- (void)sideMenuPadDidSelectIndex:(NSInteger)index{
    [self setupRightVCWithIndex:index];
}

@end

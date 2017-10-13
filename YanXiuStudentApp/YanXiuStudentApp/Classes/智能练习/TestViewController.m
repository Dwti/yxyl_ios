//
//  TestViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "TestViewController.h"
#import "VideoPlayManagerView.h"

@interface TestViewController ()
@property (nonatomic, strong) VideoPlayManagerView *playMangerView;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.playMangerView viewWillAppear];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.playMangerView viewWillDisappear];
}

- (void)setupUI {
//    self.playMangerView = [[VideoPlayManagerView alloc] initWithType:VideoPlayFromType_PromptView];
//    self.playMangerView = [[VideoPlayManagerView alloc] initWithType:VideoPlayFromType_PlayButton];

//    self.playMangerView.url = self.url;
    WEAK_SELF
    [self.playMangerView setVideoPlayManagerViewRotateScreenBlock:^(BOOL isVertical) {
        STRONG_SELF
        [self rotateScreenAction];
    }];
    [self.playMangerView setVideoPlayManagerViewBackActionBlock:^{
        STRONG_SELF
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }];
    [self.playMangerView setVideoPlayManagerViewFinishBlock:^{
        STRONG_SELF
        //        [self.chapterVC readyNextWillplayVideoAgain:NO];
    }];
    [self.playMangerView setVideoPlayManagerViewPlayVideoBlock:^(VideoPlayManagerStatus status) {
        STRONG_SELF
        //        if (status == ActivityPlayManagerStatus_Unknown) {
        //            YXWebViewController *VC = [[YXWebViewController alloc] init];
        //            VC.urlString = [self.toolVideoItem.body formatToolVideo].external_url;
        //            VC.isUpdatTitle = YES;
        //            [self.navigationController pushViewController:VC animated:YES];
        //        }else {
        //            [self requestForActivityToolVideo];
        //        }
    }];
    [self.view addSubview:self.playMangerView];
//    [self remakeForFullSize];
//    [self rotateScreenAction];
    [self remakeForHalfSize];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    if (size.width > size.height) {
        [self remakeForFullSize];
    }else{
        [self remakeForHalfSize];
    }
}

- (void)remakeForFullSize {
    self.playMangerView.isFullscreen = YES;
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.view layoutIfNeeded];
}

- (void)remakeForHalfSize {
    self.playMangerView.isFullscreen = NO;
    self.navigationController.navigationBar.hidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [self.playMangerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.playMangerView.mas_width).multipliedBy(9.0 / 15.6).priority(999);
    }];
    [self.view layoutIfNeeded];
}

- (void)rotateScreenAction {
    UIInterfaceOrientation screenDirection = [UIApplication sharedApplication].statusBarOrientation;
    if(screenDirection == UIInterfaceOrientationLandscapeLeft || screenDirection ==UIInterfaceOrientationLandscapeRight){
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    }else{
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    }
}

- (void)naviLeftAction{
    UIInterfaceOrientation screenDirection = [UIApplication sharedApplication].statusBarOrientation;
    if(screenDirection == UIInterfaceOrientationLandscapeLeft || screenDirection ==UIInterfaceOrientationLandscapeRight){
        [self rotateScreenAction];
    }else{
        [self.playMangerView playVideoClear];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0) {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)removePlayMangerView {
    [self.playMangerView viewWillDisappear];
    [self.playMangerView removeFromSuperview];
}
@end

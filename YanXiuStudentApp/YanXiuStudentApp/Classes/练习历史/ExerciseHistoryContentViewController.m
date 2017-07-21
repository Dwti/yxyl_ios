//
//  ExerciseHistoryContentViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseHistoryContentViewController.h"
#import "YXChapterPointSegmentControl.h"
#import "YXGetPracticeEditionRequest.h"
#import "ExerciseHistoryKnpViewController.h"
#import "ExerciseHistoryChapterViewController.h"
#import "YXChooseVolumnView.h"

@interface ExerciseHistoryContentViewController ()
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) YXChooseVolumnButton *chooseVolumeButton;
@property (nonatomic, strong) YXChooseVolumnView *chooseVolumeView;
@property (nonatomic, strong) ExerciseHistoryKnpViewController *knpVC;
@property (nonatomic, strong) ExerciseHistoryChapterViewController *chapterVC;

@property (nonatomic, strong) NSArray *volumeArray;
@end

@implementation ExerciseHistoryContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.subject.name;
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    [self requestVolumes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self requestVolumes];
    }];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
}

- (void)requestVolumes {
    [self yx_startLoading];
    WEAK_SELF
    [[ExerciseSubjectManager sharedInstance]requestVolumesWithSubjectID:self.subject.subjectID editionID:self.subject.edition.editionId completeBlock:^(NSArray *volumeArray, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            self.errorView.hidden = NO;
            return;
        }
        self.volumeArray = volumeArray;
        [self setupTopView];
        [self setupBottomView];
        [self setupVolumeChooseView];
    }];
}

- (void)setupTopView {
    UIView *topContainerView = [[UIView alloc] init];
    topContainerView.backgroundColor = [UIColor whiteColor];
    topContainerView.clipsToBounds = YES;
    topContainerView.layer.shadowOffset = CGSizeMake(0, 1);
    topContainerView.layer.shadowOpacity = 0.02;
    topContainerView.layer.shadowColor = [UIColor colorWithHexString:@"002c0f"].CGColor;
    [self.view addSubview:topContainerView];
    [topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    self.topContainerView = topContainerView;
    
    YXChapterPointSegmentControl *chooseChapterPointControl = [[YXChapterPointSegmentControl alloc] init];
    chooseChapterPointControl.name = self.subject.name;
    [topContainerView addSubview:chooseChapterPointControl];
    [chooseChapterPointControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(chooseChapterPointControl.frame.size);
    }];
    [chooseChapterPointControl addTarget:self action:@selector(chapterPointValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (self.volumeArray.count == 0) {
        return;
    }
    YXChooseVolumnButton *chooseVolumnButton = [[YXChooseVolumnButton alloc] init];
    chooseVolumnButton.bExpand = NO;
    [topContainerView addSubview:chooseVolumnButton];
    [chooseVolumnButton addTarget:self action:@selector(chooseVolumnAction:) forControlEvents:UIControlEventTouchUpInside];
    GetEditionRequestItem_edition_volume *volume = self.volumeArray[0];
    CGSize size = [chooseVolumnButton updateWithTitle:volume.name];
    [chooseVolumnButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(size);
    }];
    self.chooseVolumeButton = chooseVolumnButton;
}

- (void)setupBottomView {
    self.chapterVC = [[ExerciseHistoryChapterViewController alloc]init];
    self.chapterVC.subject = self.subject;
    GetEditionRequestItem_edition_volume *volume = self.volumeArray[0];
    self.chapterVC.volumeID = volume.volumeID;
    [self.view addSubview:self.chapterVC.view];
    [self.chapterVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topContainerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.knpVC = [[ExerciseHistoryKnpViewController alloc]init];
    self.knpVC.subject = self.subject;
    [self.view addSubview:self.knpVC.view];
    [self.knpVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topContainerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.knpVC.view.hidden = YES;
    
    [self addChildViewController:self.chapterVC];
    [self addChildViewController:self.knpVC];
}

- (void)setupVolumeChooseView {
    self.chooseVolumeView = [[YXChooseVolumnView alloc] init];
    GetEditionRequestItem_edition_volume *volume = self.volumeArray[0];
    CGSize size = [self.chooseVolumeView.chooseVolumnButton updateWithTitle:volume.name];
    [self.chooseVolumeView.chooseVolumnButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(65);
        make.right.mas_equalTo(-15);
        make.size.mas_equalTo(size);
    }];
    @weakify(self);
    self.chooseVolumeView.chooseBlock = ^(NSInteger index) {
        @strongify(self); if (!self) return;
        GetEditionRequestItem_edition_volume *volume = self.volumeArray[index];
        CGSize size = [self.chooseVolumeButton updateWithTitle:volume.name];
        [self.chooseVolumeView.chooseVolumnButton updateWithTitle:volume.name];
        [self.chooseVolumeView removeFromSuperview];
        [self.chooseVolumeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(size);
        }];
        [self.chooseVolumeView.chooseVolumnButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(65);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(size);
        }];
        self.chapterVC.volumeID = volume.volumeID;
    };
    [self.chooseVolumeView updateWithDatas:self.volumeArray
                             selectedIndex:0];
}

#pragma mark - Actions
- (void)chapterPointValueChanged:(YXChapterPointSegmentControl *)seg {
    if (seg.curSelectedIndex == 0) {
        self.chapterVC.view.hidden = NO;
        self.knpVC.view.hidden = YES;
        self.chooseVolumeButton.hidden = NO;
    }else{
        self.chapterVC.view.hidden = YES;
        self.knpVC.view.hidden = NO;
        self.chooseVolumeButton.hidden = YES;
    }
}

- (void)chooseVolumnAction:(YXChooseVolumnButton *)sender {
    [self.view.window addSubview:self.chooseVolumeView];
    [self.view.window bringSubviewToFront:self.chooseVolumeView];
    
    [self.chooseVolumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

@end

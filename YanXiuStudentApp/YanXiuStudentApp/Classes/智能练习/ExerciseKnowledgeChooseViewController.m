//
//  ExerciseKnowledgeChooseViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "ExerciseKnowledgeChooseViewController.h"
#import "YXCommonErrorView.h"
#import "YXChapterPointSegmentControl.h"
#import "YXChooseVolumnButton.h"
#import "YXChooseVolumnView.h"
#import "ExerciseChapterTreeViewController.h"
#import "ExerciseKnpTreeViewController.h"

@interface ExerciseKnowledgeChooseViewController ()
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) YXChooseVolumnView *chooseVolumeView;
@property (nonatomic, strong) YXChooseVolumnButton *chooseVolumeButton;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) NSArray *volumeArray;

@property (nonatomic, strong) ExerciseChapterTreeViewController *chapterVC;
@property (nonatomic, strong) ExerciseKnpTreeViewController *knpVC;
@end

@implementation ExerciseKnowledgeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.subject.name;
    [self yx_setupLeftBackBarButtonItem];
    [self setupUI];
    [self requestVolumes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI{
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"练习-背景-拷贝"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
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
    topContainerView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    topContainerView.clipsToBounds = YES;
    [self.view addSubview:topContainerView];
    UIView *sepView = [[UIView alloc] init];
    sepView.backgroundColor = [UIColor colorWithHexString:@"007373"];
    [topContainerView addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    [topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(58);
    }];
    self.topContainerView = topContainerView;
    
    // 章节考点控件
    YXChapterPointSegmentControl *chooseChapterPointControl = [[YXChapterPointSegmentControl alloc] init];
    chooseChapterPointControl.name = self.subject.name;
    [topContainerView addSubview:chooseChapterPointControl];
    [chooseChapterPointControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(chooseChapterPointControl.frame.size);
    }];
    [chooseChapterPointControl addTarget:self action:@selector(chapterPointValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // 册button
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
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(size);
    }];
    self.chooseVolumeButton = chooseVolumnButton;
}

- (void)setupBottomView {
    self.chapterVC = [[ExerciseChapterTreeViewController alloc]init];
    self.chapterVC.subjectID = self.subject.subjectID;
    self.chapterVC.editionID = self.subject.edition.editionId;
    GetEditionRequestItem_edition_volume *volume = self.volumeArray[0];
    self.chapterVC.volumeID = volume.volumeID;
    [self.view addSubview:self.chapterVC.view];
    [self.chapterVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topContainerView.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.knpVC = [[ExerciseKnpTreeViewController alloc]init];
    self.knpVC.subjectID = self.subject.subjectID;
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
    @weakify(self);
    self.chooseVolumeView.chooseBlock = ^(NSInteger index) {
        @strongify(self); if (!self) return;
        GetEditionRequestItem_edition_volume *volume = self.volumeArray[index];
        CGSize size = [self.chooseVolumeButton updateWithTitle:volume.name];
        self.chooseVolumeButton.bExpand = YES;
        [self chooseVolumnAction:self.chooseVolumeButton];
        [self.chooseVolumeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.size.mas_equalTo(size);
        }];
        self.chapterVC.volumeID = volume.volumeID;
    };
    [self.chooseVolumeView updateWithDatas:self.volumeArray
                              selectedIndex:0];
    
    [self.view addSubview:self.chooseVolumeView];
    [self.view sendSubviewToBack:self.chooseVolumeView];
    
    [self.chooseVolumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(-20);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
    }];
}

#pragma mark - Actions
- (void)chapterPointValueChanged:(YXChapterPointSegmentControl *)seg {
    [self chooseVolumnAction:nil];
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
    sender.bExpand = !sender.bExpand;
    [self.view bringSubviewToFront:self.topContainerView];
    [self.view insertSubview:self.chooseVolumeView belowSubview:self.topContainerView];
    if (sender.bExpand) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.chooseVolumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(58);
                make.bottom.left.right.mas_equalTo(0);
            }];
            [self.view layoutIfNeeded];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            [self.chooseVolumeView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(-20);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(20);
            }];
            [self.view layoutIfNeeded];
        }];
    }
}

@end

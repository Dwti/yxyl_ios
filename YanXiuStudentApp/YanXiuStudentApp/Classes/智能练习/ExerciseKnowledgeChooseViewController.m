//
//  ExerciseKnowledgeChooseViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/31.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ExerciseKnowledgeChooseViewController.h"
#import "YXCommonErrorView.h"
#import "YXChapterPointSegmentControl.h"
#import "YXChooseVolumnButton.h"
#import "YXChooseVolumnView.h"
#import "ExerciseChapterTreeViewController.h"
#import "ExerciseKnpTreeViewController.h"
#import "ChooseEditionViewController.h"

@interface ExerciseKnowledgeChooseViewController ()
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) YXChooseVolumnView *chooseVolumeView;
@property (nonatomic, strong) YXChapterPointSegmentControl *chooseChapterPointControl;
@property (nonatomic, strong) YXChooseVolumnButton *chooseVolumeButton;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) ExerciseChapterTreeViewController *chapterVC;
@property (nonatomic, strong) ExerciseKnpTreeViewController *knpVC;

@property (nonatomic, strong) NSArray *volumeArray;
@property (nonatomic, strong) GetEditionRequestItem_edition_volume *chooseVolume;

@end

@implementation ExerciseKnowledgeChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.subject.name;
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    [self requestVolumes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backAction {
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[ChooseEditionViewController class]]) {
            [vcArray removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = vcArray;
    [super backAction];
}
- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestVolumes];
    }];
}

- (void)requestVolumes {
    [self.view nyx_startLoading];
    WEAK_SELF
    [[ExerciseSubjectManager sharedInstance]requestVolumesWithSubjectID:self.subject.subjectID editionID:self.subject.edition.editionId completeBlock:^(NSArray *volumeArray, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        [self.errorView removeFromSuperview];
        self.volumeArray = volumeArray;
        [self setupBottomView];
        [self setupTopView];
        [self setupVolumeChooseView];
    }];
}

- (void)setupTopView {
    UIView *topContainerView = [[UIView alloc] init];
    topContainerView.backgroundColor = [UIColor whiteColor];
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
    
    // 章节考点控件
    YXChapterPointSegmentControl *chooseChapterPointControl = [[YXChapterPointSegmentControl alloc] init];
    chooseChapterPointControl.name = self.subject.name;
    [topContainerView addSubview:chooseChapterPointControl];
    [chooseChapterPointControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(chooseChapterPointControl.frame.size);
    }];
    [chooseChapterPointControl addTarget:self action:@selector(chapterPointValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.chooseChapterPointControl = chooseChapterPointControl;
    
    // 册button
    if (self.volumeArray.count == 0) {
        return;
    }
    YXChooseVolumnButton *chooseVolumnButton = [[YXChooseVolumnButton alloc] init];
    self.chooseVolumeButton = chooseVolumnButton;
    chooseVolumnButton.bExpand = NO;
    [topContainerView addSubview:chooseVolumnButton];
    [chooseVolumnButton addTarget:self action:@selector(chooseVolumnAction:) forControlEvents:UIControlEventTouchUpInside];
    GetEditionRequestItem_edition_volume *volume = self.volumeArray[0];
    CGSize size = [chooseVolumnButton updateWithTitle:volume.name];
    [self setupChooseVolumeButtonLayoutWithSize:size];
}

- (void)setupChooseVolumeButtonLayoutWithSize:(CGSize)size {
    if (self.chooseChapterPointControl.hidden == YES) {
        [self.chooseVolumeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.size.mas_equalTo(size);
        }];
    }else {
        [self.chooseVolumeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(size);
        }];
    }
}

- (void)setupBottomView {
    self.chapterVC = [[ExerciseChapterTreeViewController alloc]init];
    self.chapterVC.subjectID = self.subject.subjectID;
    self.chapterVC.editionID = self.subject.edition.editionId;
    GetEditionRequestItem_edition_volume *volume = self.volumeArray[0];
    self.chapterVC.volumeID = volume.volumeID;
    [self.view addSubview:self.chapterVC.view];
    [self.chapterVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    self.knpVC = [[ExerciseKnpTreeViewController alloc]init];
    self.knpVC.subjectID = self.subject.subjectID;
    [self.view addSubview:self.knpVC.view];
    [self.knpVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(55);
        make.left.right.bottom.mas_equalTo(0);
    }];
    self.knpVC.view.hidden = YES;
    
    [self addChildViewController:self.chapterVC];
    [self addChildViewController:self.knpVC];
}

- (void)setupVolumeChooseView {
    self.chooseVolumeView = [[YXChooseVolumnView alloc] init];
    WEAK_SELF
    self.chooseVolumeView.chooseBlock = ^(NSInteger index, BOOL isChanged) {
        STRONG_SELF
         self.chooseVolumeButton.bExpand = NO;
        if (!isChanged) {
             [self.chooseVolumeView removeFromSuperview];
            return;
        }
        GetEditionRequestItem_edition_volume *volume = self.volumeArray[index];
        self.chooseVolume = volume;
        CGSize size = [self.chooseVolumeButton updateWithTitle:volume.name];
        
        [self setupChooseVolumeButtonLayoutWithSize:size];
       
        [self.chooseVolumeView removeFromSuperview];
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
    self.chooseVolumeView.frame = self.view.window.bounds;
    self.chooseVolumeButton.bExpand = YES;
    NSUInteger index = [self.volumeArray containsObject:self.chooseVolume] ? [self.volumeArray indexOfObject:self.chooseVolume] : 0;
    [self.chooseVolumeView updateWithDatas:self.volumeArray
                             selectedIndex:index];
    [self.chooseVolumeView showWithAnmination];

}

@end

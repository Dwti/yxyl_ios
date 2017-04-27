//
//  MistakeListViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/27/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeAllViewController.h"
#import "MistakeQuestionManager.h"
#import "MistakeSegmentView.h"
#import "MistakeChapterViewController.h"
#import "MistakeKnpViewController.h"
#import "MistakeListViewController.h"
#import "YXErrorsPagedListFetcher.h"

@interface MistakeAllViewController ()
@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) MistakeSegmentView *segmentView;
@property (nonatomic, strong) MistakeListViewController *listViewController;
@property (nonatomic, strong) MistakeChapterViewController *chapterViewController;
@property (nonatomic, strong) MistakeKnpViewController *knpViewController;
@end

@implementation MistakeAllViewController
- (void)dealloc {
    DDLogError(@"release=====>>%@",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.subject.name;
    [self yx_setupLeftBackBarButtonItem];
    [self setupUI];
    [self setupLayout];
    [self setupViewControllers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupUI {
    self.bgImageView = [[UIImageView alloc] init];
    self.bgImageView.image = [UIImage imageNamed:@"背景01"];
    self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.bgImageView];
    
    self.topContainerView= [[UIView alloc] init];
    self.topContainerView.backgroundColor = [UIColor colorWithHexString:@"008080"];
    self.topContainerView.clipsToBounds = YES;
    [self.view addSubview:self.topContainerView];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"007373"];
    [self.topContainerView addSubview:self.lineView];
    
    self.segmentView = [[MistakeSegmentView alloc] initWithSubject:self.subject.data];
    self.segmentView.clipsToBounds = YES;
    [self.view addSubview:self.segmentView];
    WEAK_SELF
    [self.segmentView setButtonTappedBlock:^(UIButton *sender) {
        STRONG_SELF
        [self changeToSelectedSegment:sender.tag];
    }];
}

- (void)setupLayout {
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topContainerView.mas_bottom);
        make.left.right.bottom.mas_offset(0);
    }];
    
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(58);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    
    [self.segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(58);
    }];
}

- (void)setupViewControllers {
    YXErrorsPagedListFetcher *dataFetcher = [[YXErrorsPagedListFetcher alloc] init];
    dataFetcher.subjectID = self.subject.subjectID;
    dataFetcher.stageID = [YXUserManager sharedManager].userModel.stageid;
    
    self.listViewController = [[MistakeListViewController alloc] initWithFetcher:dataFetcher];
    self.listViewController.subject = self.subject;
    self.listViewController.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.listViewController.view];
    [self.listViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topContainerView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    [self addChildViewController:self.listViewController];
    self.listViewController.view.hidden = NO;

    if (![self.segmentView isShowChapterButton] && ![self.segmentView isShowKnpButton]) {
        [self.segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(0);
        }];
        self.segmentView.hidden = YES;
    } else {
        [self.segmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(58);
        }];
        [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(58);
        }];
        self.segmentView.hidden = NO;
        if ([self.segmentView isShowChapterButton]) {
            self.chapterViewController = [[MistakeChapterViewController alloc] init];
            self.chapterViewController.subject = self.subject;
            self.chapterViewController.subjectID = self.subject.subjectID;
            self.chapterViewController.editionID = self.subject.data.editionId;
            [self.view addSubview:self.chapterViewController.view];
            [self.chapterViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.topContainerView.mas_bottom);
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            [self addChildViewController:self.chapterViewController];
            self.chapterViewController.view.hidden = YES;
        }
      
        if ([self.segmentView isShowKnpButton]) {
            self.knpViewController = [[MistakeKnpViewController alloc] init];
            self.knpViewController.subject = self.subject;
            self.knpViewController.subjectID = self.subject.subjectID;
            self.knpViewController.editionID = self.subject.data.editionId;
            [self.view addSubview:self.knpViewController.view];
            [self.knpViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.topContainerView.mas_bottom);
                make.left.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            
            [self addChildViewController:self.knpViewController];
            self.knpViewController.view.hidden = YES;
        }
    }
}

- (void)changeToSelectedSegment:(NSInteger)index {
    if (index == 0) {
        self.listViewController.view.hidden = NO;
        self.chapterViewController.view.hidden = YES;
        self.knpViewController.view.hidden = YES;
    } else if (index == 1) {
        self.listViewController.view.hidden = YES;
        self.chapterViewController.view.hidden = NO;
        self.knpViewController.view.hidden = YES;
    } else {
        self.listViewController.view.hidden = YES;
        self.chapterViewController.view.hidden = YES;
        self.knpViewController.view.hidden = NO;
    }
}

@end

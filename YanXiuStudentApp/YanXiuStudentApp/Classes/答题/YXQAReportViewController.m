//
//  YXQAAnalysisSheetViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/17/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXQAReportViewController.h"
#import "YXJieXiViewController.h"
#import "YXJieXiFoldUnfoldViewController.h"
#import "YXAnswerQuestionViewController.h"
#import "YXShareManager.h"
#import "YXBottomGradientView.h"
#import "YXQAReportTitleCell.h"
#import "YXQAReportCorrectRateCell.h"
#import "YXQAReportQuestionItemCell.h"
#import "YXQAReportGroupHeaderView.h"
#import "YXGetSectionQBlockRequest.h"
#import "YXGenKnpointQBlockRequest.h"
#import "ReportShareAlertView.h"

@interface YXQAReportViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *groupArray;
@property (nonatomic, assign) CGFloat bottomButtonHeight;
@property (nonatomic, strong) YXGetSectionQBlockRequest *chapterRequest;
@property (nonatomic, strong) YXGenKnpointQBlockRequest *knpRequest;
@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) ReportShareAlertView *containerView;
@end

@implementation YXQAReportViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[YXAnswerQuestionViewController class]]) {
            [vcArray removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = vcArray;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.canDoExerciseAgain) {
        self.bottomButtonHeight = 60;
    }
    
    self.groupArray = [self.model questionGroups];
    self.analysisDataConfig = [[YXQAAnalysisDataConfig alloc]init];
    UIImageView *bgView = [[UIImageView alloc]init];
    bgView.image = [UIImage imageNamed:@"桌面"];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UIImage *greenBGImage = [UIImage imageNamed:@"塑料底板"];
    greenBGImage = [greenBGImage stretchableImageWithLeftCapWidth:100 topCapHeight:100];
    UIImageView *greenBgView = [[UIImageView alloc]initWithImage:greenBGImage];
    [self.view addSubview:greenBgView];
    [greenBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(66, 15, 39+self.bottomButtonHeight, 11));
    }];
    
    UIImage *paperImage = [UIImage imageNamed:@"纸张"];
    paperImage = [paperImage stretchableImageWithLeftCapWidth:100 topCapHeight:100];
    UIImageView *paperBgView = [[UIImageView alloc]initWithImage:paperImage];
    paperBgView.userInteractionEnabled = YES;
    paperBgView.clipsToBounds = YES;
    [self.view addSubview:paperBgView];
    [paperBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(66);
        make.right.mas_equalTo(-26);
        make.bottom.mas_equalTo(-39-33-self.bottomButtonHeight);
    }];
    
    UIImageView *pencilView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"报告-铅笔"]];
    [self.view addSubview:pencilView];
    [pencilView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(94);
        make.bottom.mas_equalTo(-5-self.bottomButtonHeight);
        make.size.mas_equalTo(CGSizeMake(89, 99));
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"返回icon"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回icon-按下"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(26);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
   
    if (self.pType != YXPTypeGroupHomework && ([YXShareManager isQQSupport] || [YXShareManager isWXAppSupport])) {
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setBackgroundImage:[UIImage imageNamed:@"分享icon"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareButton];
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(26);
            make.size.mas_equalTo(CGSizeMake(28, 28));
        }];
    }
    
    UIButton *titleButton = [[UIButton alloc]init];
    titleButton.userInteractionEnabled = NO;
    [titleButton setBackgroundImage:[UIImage imageNamed:@"练习报告夹子"] forState:UIControlStateNormal];
    if (self.pType == YXPTypeGroupHomework) {
        [titleButton setTitle:@"作业报告" forState:UIControlStateNormal];
    }else{
        [titleButton setTitle:@"练习报告" forState:UIControlStateNormal];
    }
    [titleButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    titleButton.titleEdgeInsets = UIEdgeInsetsMake(9, 0, -9, 0);
    titleButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    titleButton.titleLabel.layer.shadowRadius = 0;
    titleButton.titleLabel.layer.shadowOpacity = 1;
    titleButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    [self.view addSubview:titleButton];
    [titleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(34);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(98, 66));
    }];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 15;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 20, 0);
    [self.collectionView registerClass:[YXQAReportTitleCell class] forCellWithReuseIdentifier:@"YXQAReportTitleCell"];
    [self.collectionView registerClass:[YXQAReportCorrectRateCell class] forCellWithReuseIdentifier:@"YXQAReportCorrectRateCell"];
    [self.collectionView registerClass:[YXQAReportQuestionItemCell class] forCellWithReuseIdentifier:@"YXQAReportQuestionItemCell"];
    [self.collectionView registerClass:[YXQAReportGroupHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXQAReportGroupHeaderView"];
    [paperBgView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
    }];
    
    YXBottomGradientView *gradientView = [[YXBottomGradientView alloc] initWithFrame:CGRectZero color:[UIColor colorWithHexString:@"fff5cc"]];
    [paperBgView addSubview:gradientView];
    [gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-6);
        make.height.mas_equalTo(40);
    }];
    
    if (self.canDoExerciseAgain) {
        UIButton *doAgainButton = [self blueBottomButton];
        [doAgainButton setTitle:@"再练一组" forState:UIControlStateNormal];
        [doAgainButton addTarget:self action:@selector(goDoAgain) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:doAgainButton];
        [doAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-10);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(100, 50));
        }];
        
    }
}

- (UIButton *)bottomButton {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 3;
    btn.layer.borderColor = [UIColor colorWithHexString:@"00a0e6"].CGColor;
    btn.layer.borderWidth = 1;
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"00a0e6"]] forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"00a0e6"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.clipsToBounds = TRUE;
    [self.view addSubview:btn];
    return btn;
}
- (UIButton *)yellowBottomButton{
    UIButton *btn = [[UIButton alloc]init];
    UIImage *normalImage = [UIImage imageNamed:@"黄按钮"];
    normalImage = [normalImage stretchableImageWithLeftCapWidth:normalImage.size.width/2 topCapHeight:normalImage.size.height/2];
    UIImage *highlightImage = [UIImage imageNamed:@"黄按钮-按下"];
    highlightImage = [highlightImage stretchableImageWithLeftCapWidth:highlightImage.size.width/2 topCapHeight:highlightImage.size.height/2];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    btn.titleLabel.layer.shadowRadius = 0;
    btn.titleLabel.layer.shadowOpacity = 1;
    btn.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    return btn;
}
- (UIButton *)blueBottomButton{
    UIButton *btn = [[UIButton alloc]init];
    UIImage *normalImage = [UIImage imageNamed:@"兰按钮"];
    normalImage = [normalImage stretchableImageWithLeftCapWidth:normalImage.size.width/2 topCapHeight:normalImage.size.height/2];
    UIImage *highlightImage = [UIImage imageNamed:@"兰按钮-按下"];
    highlightImage = [highlightImage stretchableImageWithLeftCapWidth:highlightImage.size.width/2 topCapHeight:highlightImage.size.height/2];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"006666"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    btn.titleLabel.layer.shadowRadius = 0;
    btn.titleLabel.layer.shadowOpacity = 1;
    btn.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"33ffff"].CGColor;
    return btn;
}
#pragma mark - button actions
- (void)goDoAgain
{
    if (self.requestParams.segment == YXExerciseListSegmentChapter) {
        [self goChapterRequest];
    }else {
        [self goKnpRequest];
    }
}

- (void)goChapterRequest {
    [self.chapterRequest stopRequest];
    self.chapterRequest = [[YXGetSectionQBlockRequest alloc] init];
    self.chapterRequest.stageId = self.requestParams.stageId;
    self.chapterRequest.subjectId = self.requestParams.subjectId;
    self.chapterRequest.editionId = self.requestParams.editionId;
    self.chapterRequest.volumeId = self.requestParams.volumeId;
    self.chapterRequest.chapterId = self.requestParams.chapterId;
    self.chapterRequest.sectionId = self.requestParams.sectionId;
    self.chapterRequest.questNum = self.requestParams.questNum;
    self.chapterRequest.cellId = self.requestParams.cellId;
    WEAK_SELF
    [YXLoadingControl startLoadingWithSuperview:self.view text:@"智能出题"];
    [self.chapterRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [YXLoadingControl stopLoadingWithSuperview:self.view];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        [self handleRequestData:retItem];
    }];
}

- (void)handleRequestData:(YXIntelligenceQuestionListItem *)item {
    YXIntelligenceQuestion *question = nil;
    if (item.data.count > 0) {
        question = item.data[0];
        YXAnswerQuestionViewController *vc = [[YXAnswerQuestionViewController alloc] init];
        vc.requestParams = self.requestParams;
        vc.model = [QAPaperModel modelFromRawData:question];
        vc.pType = self.pType;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goKnpRequest {
    [self.knpRequest stopRequest];
    self.knpRequest = [[YXGenKnpointQBlockRequest alloc] init];
    self.knpRequest.stageId = self.requestParams.stageId;
    self.knpRequest.subjectId = self.requestParams.subjectId;
    self.knpRequest.questNum = self.requestParams.questNum;
    self.knpRequest.knpId1 = self.requestParams.chapterId;
    self.knpRequest.knpId2 = self.requestParams.sectionId;
    self.knpRequest.knpId3 = self.requestParams.cellId;
    self.knpRequest.fromType = self.requestParams.fromType;
    WEAK_SELF
    [YXLoadingControl startLoadingWithSuperview:self.view text:@"智能出题"];
    [self.knpRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [YXLoadingControl stopLoadingWithSuperview:self.view];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        [self handleRequestData:retItem];
    }];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)shareAction{
    self.alertView = [[EEAlertView alloc] init];
    
    self.containerView = [[ReportShareAlertView alloc] init];
    
    WEAK_SELF
    [self.containerView setCancelAction:^{
        STRONG_SELF
        [UIView animateWithDuration:0.3f animations:^{
            [self.alertView.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(306);
                make.centerX.mas_equalTo(0);
                make.top.equalTo(self.alertView.mas_bottom).offset(0);
            }];
            [self.alertView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self.alertView removeFromSuperview];
        }];
    }];
    
    [self.containerView setShareAction:^(UIButton *sender) {
        STRONG_SELF
        if (sender.tag == 0) {
            [self shareWithType:YXShareType_TcQQ];
        } else if (sender.tag == 1) {
            [self shareWithType:YXShareType_TcZone];
        } else if (sender.tag == 2) {
            [self shareWithType:YXShareType_WeChat];
        } else if (sender.tag == 3) {
            [self shareWithType:YXShareType_WeChatFriend];
        }
        
        [UIView animateWithDuration:0.3f animations:^{
            [self.alertView.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(306);
                make.centerX.mas_equalTo(0);
                make.top.equalTo(self.alertView.mas_bottom).offset(0);
            }];
            [self.alertView layoutIfNeeded];
            
        } completion:^(BOOL finished) {
            [self.alertView removeFromSuperview];
        }];

    }];
    
    self.alertView.contentView = self.containerView;
    [self.alertView showWithLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(306);
            make.centerX.mas_equalTo(0);
            make.top.equalTo(view.mas_bottom).offset(0);
        }];
        [view layoutIfNeeded];
        
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(306);
                make.centerX.mas_equalTo(0);
                make.bottom.mas_equalTo(-30);
            }];
            [view layoutIfNeeded];
        }];
    }];
}

- (void)shareWithType:(YXShareType)shareType {
    [[YXShareManager shareManager]shareWithType:shareType model:self.model networkErrorBlock:^{
        [self yx_showToast:@"网络异常，请稍后重试"];
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.groupArray.count + 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
    QAQuestionGroup *group = self.groupArray[section-2];
    return group.questions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        YXQAReportTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXQAReportTitleCell" forIndexPath:indexPath];
        cell.title = self.model.paperTitle;
        cell.duration = self.model.paperAnswerDuration;
        if (self.pType == YXPTypeGroupHomework) {
            cell.image = [UIImage imageNamed:@"作业报告印章"];
        }else{
            cell.image = [UIImage imageNamed:@"练习印章"];
        }
        return cell;
    }else if (indexPath.section == 1){
        YXQAReportCorrectRateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXQAReportCorrectRateCell" forIndexPath:indexPath];
        cell.correctRate = [self.model correctRate];
        return cell;
    }else{
        YXQAReportQuestionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YXQAReportQuestionItemCell" forIndexPath:indexPath];
        QAQuestionGroup *group = self.groupArray[indexPath.section-2];
        cell.item = group.questions[indexPath.row];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 2) {
        return nil;
    }
    if (kind == UICollectionElementKindSectionHeader) {
        YXQAReportGroupHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"YXQAReportGroupHeaderView" forIndexPath:indexPath];
        QAQuestionGroup *group = self.groupArray[indexPath.section-2];
        headerView.title = group.name;
        return headerView;
    }
    return nil;
}


#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section >= 2) {
        return CGSizeMake(collectionView.frame.size.width, 35.f);
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return CGSizeMake(collectionView.frame.size.width, 100);
    }else if (indexPath.section == 1){
        return CGSizeMake(collectionView.frame.size.width, 45);
    }
    return CGSizeMake(45, 45);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 0;
    }
    CGFloat gap = (collectionView.frame.size.width-40-(45+3)*5)/4;
    return MAX(gap, 0.f);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section >= 2) {
        return UIEdgeInsetsMake(0, 20, 25, 20);
    }
    return UIEdgeInsetsZero;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 2) {
        return;
    }
    QAQuestionGroup *group = self.groupArray[indexPath.section-2];
    QAQuestion *item = group.questions[indexPath.row];
    YXJieXiViewController *vc = [[YXJieXiViewController alloc]init];
    vc.requestParams = self.requestParams;
    vc.model = self.model;
    vc.firstLevel = item.position.firstLevelIndex;
    vc.secondLevel = item.position.secondLevelIndex;
    vc.pType = self.pType;
    vc.canDoExerciseFromKnp = self.canDoExerciseAgain;
    vc.analysisDataDelegate = self.analysisDataConfig;
    [self.navigationController pushViewController:vc animated:YES];
}

@end

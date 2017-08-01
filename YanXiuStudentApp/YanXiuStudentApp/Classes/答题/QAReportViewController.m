//
//  QAReportViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QAReportViewController.h"
#import "QAQuestionNumberButton.h"
#import "QAReportQuestionItemCell.h"
#import "QAReportGroupHeaderView.h"
#import "QAReportTitleCell.h"
#import "QAAnswerDetailsCell.h"
#import "QAReportNavView.h"
#import "QAAnswerSheetViewController.h"
#import "QAAnswerQuestionViewController.h"
#import "QAAnalysisViewController.h"
#import "YXGetSectionQBlockRequest.h"
#import "YXGenKnpointQBlockRequest.h"

static const CGFloat kItemWidth = 60;
static const CGFloat kMinMargin = 15;
static const CGFloat kNavViewHeight = 55.0f;

@interface QAReportViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) QAReportNavView *navView;
@property (nonatomic, strong) NSArray *groupArray;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat titleHeight;

@property (nonatomic, strong) YXGetSectionQBlockRequest *chapterRequest;
@property (nonatomic, strong) YXGenKnpointQBlockRequest *knpRequest;
@end

@implementation QAReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    self.groupArray = [self.model questionGroups];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    NSMutableArray *vcArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[QAAnswerSheetViewController class]]) {
            [vcArray removeObject:vc];
            break;
        }
    }
    for (UIViewController *vc in vcArray) {
        if ([vc isKindOfClass:[QAAnswerQuestionViewController class]]) {
            [vcArray removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = vcArray;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat width = kItemWidth + kMinMargin;
    NSInteger count = (SCREEN_WIDTH - kMinMargin)/width;
    CGFloat margin = (SCREEN_WIDTH - count * kItemWidth )/(count + 1);
    self.margin = margin;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.alwaysBounceVertical = YES;
    self.collectionView.directionalLockEnabled = YES;
    [self.collectionView registerClass:[QAReportQuestionItemCell class] forCellWithReuseIdentifier:@"QAReportQuestionItemCell"];
    [self.collectionView registerClass:[QAReportTitleCell class] forCellWithReuseIdentifier:@"QAReportTitleCell"];
    [self.collectionView registerClass:[QAAnswerDetailsCell class] forCellWithReuseIdentifier:@"QAAnswerDetailsCell"];
    [self.collectionView registerClass:[QAReportGroupHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QAReportGroupHeaderView"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    if (self.canDoExerciseAgain) {
        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 75, 0);
        [self setupDoExerciseAgainButton];
    }
    
    self.navView = [[QAReportNavView alloc]init];
    self.navView.title = self.model.paperTitle;
    WEAK_SELF
    [self.navView setBackActionBlock:^{
        STRONG_SELF
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavViewHeight *kPhoneWidthRatio);
    }];
}

- (void)setupDoExerciseAgainButton {
    UIButton *exerciseAgainButton = [[UIButton alloc]init];
    exerciseAgainButton.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    exerciseAgainButton.layer.cornerRadius = 6.0f;
    exerciseAgainButton.clipsToBounds = YES;
    [exerciseAgainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exerciseAgainButton setTitle:@"再练一组" forState:UIControlStateNormal];
    [exerciseAgainButton setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateNormal];
    [exerciseAgainButton setBackgroundImage:[UIImage yx_createImageWithColor:[UIColor colorWithHexString:@"69ad0a"]] forState:UIControlStateHighlighted];
    [exerciseAgainButton addTarget:self action:@selector(goDoAgainAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exerciseAgainButton];
    [exerciseAgainButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(250 *kPhoneWidthRatio);
        make.bottom.mas_equalTo(-25);
    }];
}

#pragma mark - button actions
- (void)goDoAgainAction
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
    [self.view nyx_startLoading];
    [self.chapterRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self handleRequestData:retItem];
    }];
}

- (void)handleRequestData:(YXIntelligenceQuestionListItem *)item {
    YXIntelligenceQuestion *question = nil;
    if (item.data.count > 0) {
        question = item.data[0];
        QAAnswerQuestionViewController *vc = [[QAAnswerQuestionViewController alloc] init];
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
    self.knpRequest.knpId4 = self.requestParams.pointId;
    self.knpRequest.fromType = self.requestParams.fromType;
    WEAK_SELF
    [self.view nyx_startLoading];
    [self.knpRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self handleRequestData:retItem];
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
    QAQuestionGroup *group = self.groupArray[section - 2];
    return group.questions.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        QAReportTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QAReportTitleCell" forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }else if (indexPath.section == 1){
        QAAnswerDetailsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QAAnswerDetailsCell" forIndexPath:indexPath];
        return cell;
    }else{
        QAReportQuestionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QAReportQuestionItemCell" forIndexPath:indexPath];
        QAQuestionGroup *group = self.groupArray[indexPath.section - 2];
        cell.item = group.questions[indexPath.row];
        WEAK_SELF
        [cell setChoseActionBlock:^(QAQuestion *item) {
            STRONG_SELF
            DDLogDebug(@"%@题目",item.stem);
            QAAnalysisViewController *vc = [[QAAnalysisViewController alloc]init];
            //            vc.requestParams = self.requestParams;
            vc.model = self.model;
            vc.firstLevel = item.position.firstLevelIndex;
            vc.secondLevel = item.position.secondLevelIndex;
            //            vc.pType = self.pType;
            //            vc.canDoExerciseFromKnp = self.canDoExerciseAgain;
            //            vc.analysisDataDelegate = self.analysisDataConfig;
            [self.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 2) {
        return nil;
    }
    if (kind == UICollectionElementKindSectionHeader) {
        QAReportGroupHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QAReportGroupHeaderView" forIndexPath:indexPath];
        QAQuestionGroup *group = self.groupArray[indexPath.section - 2];
        headerView.title = group.name;
        return headerView;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section >= 2) {
        if (section == 2) {
            return CGSizeMake(collectionView.frame.size.width, 45.0f * kPhoneWidthRatio);
        }
        return CGSizeMake(collectionView.frame.size.width, 24.0f * kPhoneWidthRatio);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.model.checked) {
            self.titleHeight = 370 *kPhoneWidthRatio;
            return CGSizeMake(collectionView.frame.size.width, self.titleHeight);
        }else {
            self.titleHeight = 270 *kPhoneWidthRatio;
            return CGSizeMake(collectionView.frame.size.width, self.titleHeight);
        }
    }else if (indexPath.section == 1){
        return CGSizeMake(collectionView.frame.size.width, 45.0f * kPhoneWidthRatio);
    }
    return CGSizeMake(kItemWidth, kItemWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 0;
    }
    return kMinMargin;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0 || section == 1) {
        return 0;
    }
    return 20.0f * kPhoneWidthRatio;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section >= 2) {
        return UIEdgeInsetsMake(20 * kPhoneWidthRatio, self.margin, 20, self.margin);
    }
    return UIEdgeInsetsZero;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat minAlphaOffset = - 64;
    CGFloat maxAlphaOffset = self.titleHeight - kNavViewHeight *kPhoneWidthRatio;
    CGFloat offset = scrollView.contentOffset.y;
    CGFloat alpha = (offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset);
    self.navView.backgroundColor = [[UIColor colorWithHexString:@"89e00d"]colorWithAlphaComponent:alpha];
}
@end

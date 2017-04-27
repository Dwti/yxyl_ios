//
//  YXMyFavorQAViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 9/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXMyFavorQAViewController_Pad.h"
#import "YXSlideView.h"
#import "YXQAMaterialView.h"

#import "YXGetFavorQRequest.h"
#import "YXDeleteFavorRequest.h"

#import "YXAddFavorRequest.h"
#import "YXDeleteAllFavorRequest.h"
#import "YXJieXiReportErrorDelegate.h"
#import "YXLoadingView.h"

#import "YXFavorAnalysisDataConfig.h"
@interface YXMyFavorQAViewController_Pad () <YXJieXiReportErrorDelegate> {
    int _curPage;
    int _pageSize;
}

@property (nonatomic, strong) YXGetFavorQRequest *request;
@property (nonatomic, strong) YXGetFavorQRequest *preRequest;
@property (nonatomic, strong) YXDeleteFavorRequest *delRequest;
@property (nonatomic, strong) YXAddFavorRequest *addFavorRequest;
@property (nonatomic, strong) YXDeleteAllFavorRequest *deleteAllRequest;

@end

@implementation YXMyFavorQAViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    self.analysisDataDelegate = [[YXFavorAnalysisDataConfig alloc] init];
    _curPage = 0;
    _pageSize = 10;
    self.dataArray = [NSMutableArray array];
    [self setupRightFavorStatus:YES];
    
    if (self.bDataFromDB) {
        NSArray *dbItemArray = nil;
        if (self.comeFrom == YXSavedExerciseComeFrom_ChapterSectionUnitFavor) {
            YXChapterSectionUnitManager *mgr = [[YXChapterSectionUnitManager alloc] init];
            mgr.comeFrom = self.comeFrom;
            NSArray *keySequence = [mgr keySequenceWithSubjectID:self.subjectId
                                                       editionID:self.editionId
                                                        volumeID:self.volumeId
                                                       chapterID:self.chapterId
                                                       sectionID:self.sectionId
                                                          unitID:self.unitId];
            
            dbItemArray = [mgr exerciseUnderKeySequence:keySequence];
        }
        
        if (self.comeFrom == YXSavedExerciseComeFrom_APCPointFavor) {
            YXABCPointManager *mgr = [[YXABCPointManager alloc] init];
            mgr.comeFrom = self.comeFrom;
            NSArray *keySequence = [mgr keySequenceWithSubjectID:self.subjectId
                                                       editionID:self.editionId
                                                        apointID:self.chapterId
                                                        bpointID:self.sectionId
                                                        cpointID:self.unitId];
            dbItemArray = [mgr exerciseUnderKeySequence:keySequence];
        }
        
        NSMutableArray *rawDataArray = [NSMutableArray array];
        for (SavedExercisesEntity *se in dbItemArray) {
            [rawDataArray addObject:se.exercise.exerciseJsonContent];
        }
        
//        for (NSString *json in rawDataArray) {
//            YXQAComplexItem *mItem = [[YXQAComplexItem alloc] initWithString:json error:nil];
//            mItem.isFavorite = YES;
//            if (!mItem.itemArray) { // 不是 YXQAComplexItem 类型
//                YXQAItem *item = [[YXQAItem alloc] initWithString:json error:nil];
//                item.isFavorite = YES;
//                [self.dataArray addObject:item];
//            }else{
//                [self.dataArray addObject:mItem];
//            }
//        }
        
        return;
    }
    
    
    // Do any additional setup after loading the view.
    for (int i = 0; i < self.total; i++) {
        [self.dataArray addObject:[NSNull null]];
    }
    
    [self.request stopRequest];
    self.request = [[YXGetFavorQRequest alloc] init];
    self.request.stageId = self.stageId;
    self.request.sectionId = self.sectionId ? self.sectionId : @"0";
    self.request.subjectId = self.subjectId;
    self.request.beditionId = self.editionId;
    self.request.volumeId = self.volumeId;
    self.request.chapterId = self.chapterId;
    self.request.pageSize = [NSString stringWithFormat:@"%@", @(_pageSize)];
    self.request.currentPage = [NSString stringWithFormat:@"%@", @(_curPage + 1)];
    
    self.request.cellId = self.unitId ? self.unitId : @"0";
    if (self.comeFrom == YXSavedExerciseComeFrom_ChapterSectionUnitFavor) {
        self.request.ptype = @"0";
    }
    if (self.comeFrom == YXSavedExerciseComeFrom_APCPointFavor) {
        self.request.beditionId = nil;
        self.request.volumeId = nil;
        self.request.ptype = @"2";
    }
    
    
    @weakify(self);
    [self.request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        if (error.code == 3) {
            [self updateDataAfterRequest:retItem];
            return;
        }
        
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        [self updateDataAfterRequest:retItem];
    }];
    [self.progressView updateWithIndex:0 total:self.dataArray.count];
}

- (void)naviRightAction {
    Reachability *r = [Reachability reachabilityForInternetConnection];
    if (![r isReachable]) {
        [self yx_showToast:@"网络异常，请稍后重试"];
        return;
    }
    if ([self.dataArray objectAtIndex:self.slideView.selectedIndex] == [NSNull null]) {
        return;
    }
    
    if ([[self.dataArray objectAtIndex:self.slideView.selectedIndex] isKindOfClass:[NSString class]]) {
        return;
    }
    
    QAQuestion *item = [self.dataArray objectAtIndex:self.slideView.selectedIndex];
    item.isFavorite = !item.isFavorite;
    [self setupRightFavorStatus:item.isFavorite];
}

- (void)naviLeftAction {
    // v1.2 数据库
    for (QAQuestion *item in self.dataArray) {
        if ([item isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        if ([item isKindOfClass:[NSString class]]) {
            continue;
        }
        // v1.2 数据库
        NSString *json = nil;//[item toJSONString];
        if (self.comeFrom == YXSavedExerciseComeFrom_ChapterSectionUnitFavor) {
            YXChapterSectionUnitManager *mgr = [[YXChapterSectionUnitManager alloc] init];
            mgr.comeFrom = YXSavedExerciseComeFrom_ChapterSectionUnitFavor;
            [mgr saveExercise:json
                    subjectID:self.subjectId
                    editionID:self.editionId
                     volumeID:self.volumeId
                    chapterID:self.chapterId
                    sectionID:self.sectionId
                       unitID:self.unitId
                   exerciseID:item.questionID];
        }
        if (self.comeFrom == YXSavedExerciseComeFrom_APCPointFavor) {
            YXABCPointManager *mgr = [[YXABCPointManager alloc] init];
            mgr.comeFrom = YXSavedExerciseComeFrom_APCPointFavor;
            [mgr saveExercise:json
                    subjectID:self.subjectId
                    editionID:self.editionId
                     apointID:self.chapterId
                     bpointID:self.sectionId
                     cpointID:self.unitId
                   exerciseID:item.questionID];
        }
    }
    
    NSMutableArray *unfavorArray = [NSMutableArray array];
    for (QAQuestion *item in self.dataArray) {
        if ([item isKindOfClass:[NSNull class]]) {
            continue;
        }
        if ([item isKindOfClass:[NSString class]]) {
            continue;
        }
        if (!item.isFavorite) {
            [unfavorArray addObject:item.questionID];
        }
    }
    if (unfavorArray.count == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
            item.enabled = NO;
        }
        [self.deleteAllRequest stopRequest];
        self.deleteAllRequest = [[YXDeleteAllFavorRequest alloc]init];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:unfavorArray options:0 error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        self.deleteAllRequest.data = jsonString;
        @weakify(self);
        [YXLoadingControl startLoadingWithSuperview:self.view text:@"正在取消收藏"];
        [self.deleteAllRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
            @strongify(self); if (!self) return;
            [YXLoadingControl stopLoadingWithSuperview:self.view];
            for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
                item.enabled = YES;
            }
            if (error) {
                [self yx_showToast:error.localizedDescription];
            }else{
                for (NSString *qid in unfavorArray) {
                    [[[YXSavedExercisesDatabaseManager alloc] init] cleanExercise:qid];
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:YXFavorChangedNotification object:nil userInfo:nil];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)updateDataAfterRequest:(YXIntelligenceQuestionListItem *)ret {
    QAPaperModel *model = [QAPaperModel modelFromRawData:ret.data.firstObject];
    NSArray *mockArray = model.questions;
    [self updateForPage:_curPage withDataArray:mockArray];
    [self.slideView reloadData];
}

- (void)updateDataAfterPreRequest:(YXIntelligenceQuestionListItem *)ret {
    QAPaperModel *model = [QAPaperModel modelFromRawData:ret.data.firstObject];
    NSArray *mockArray = model.questions;
    [self updateForPage:_curPage + 1 withDataArray:mockArray];
}

- (void)updateForPage:(NSInteger)page withDataArray:(NSArray *)arr {
    if (page > (self.total + _pageSize - 1)/_pageSize - 1) {
        return;
    }
    
    int i = 0;
    for (id mock in arr) {
        NSInteger index = i + page*_pageSize;
        if (index >= self.total) {
            break;
        }
        [self.dataArray replaceObjectAtIndex:index withObject:mock];
        i++;
    }
    
    int expectNumber = _pageSize;
    if (page == (self.total + _pageSize - 1)/_pageSize - 1) {
        expectNumber = self.total % _pageSize;
        if (expectNumber == 0) {
            expectNumber = _pageSize;
        }
    }
    if (expectNumber > [arr count]) {
        for (int i = 0; i < expectNumber - [arr count]; i++) {
            NSInteger index = page*_pageSize + expectNumber - 1 - i;
            [self.dataArray replaceObjectAtIndex:index withObject:@"server没数据"];
        }
    }
}

#pragma mark - slideview
- (NSInteger)total {
    return [self.rawModel.data.favoriteNum integerValue];
}

- (NSInteger)numberOfItemsInSlideView:(YXSlideView *)sender {
    return [self total];
}

- (void)slideView:(YXSlideView *)aView slideFromIndex:(NSUInteger)from ToIndex:(NSUInteger)to {
    [self.progressView updateWithIndex:to total:self.dataArray.count];
    if (self.bDataFromDB) {
        return;
    }
    int needPage = (int)to / (int)_pageSize + 1;
    // 提前3页预加载
    if (to == (_curPage + 1) * _pageSize - 3) {
        if ((self.total + _pageSize - 1) / _pageSize < (needPage + 1)) {
            // 超出页码不用预取
            return;
        }
        [self.preRequest stopRequest];
        self.preRequest = [[YXGetFavorQRequest alloc] init];
        self.preRequest.stageId = self.stageId;
        self.preRequest.sectionId = self.sectionId ? self.sectionId : @"0";
        self.preRequest.subjectId = self.subjectId;
        self.preRequest.beditionId = self.editionId;
        self.preRequest.volumeId = self.volumeId;
        self.preRequest.chapterId = self.chapterId;
        self.preRequest.pageSize = [NSString stringWithFormat:@"%@", @(_pageSize)];
        self.preRequest.currentPage = [NSString stringWithFormat:@"%@", @(needPage + 1)];
        
        self.preRequest.cellId = self.unitId ? self.unitId : @"0";
        if (self.comeFrom == YXSavedExerciseComeFrom_ChapterSectionUnitFavor) {
            self.preRequest.ptype = @"0";
        }
        if (self.comeFrom == YXSavedExerciseComeFrom_APCPointFavor) {
            self.preRequest.beditionId = nil;
            self.preRequest.volumeId = nil;
            
            self.preRequest.ptype = @"2";
        }
        @weakify(self);
        [self.preRequest startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
            @strongify(self);
            if (error) {
                [self yx_showToast:error.localizedDescription];
                return;
            }
            [self updateDataAfterPreRequest:retItem];
        }];
    }
    QAQuestion *item = self.dataArray[to];
    if ([item isKindOfClass:[NSNull class]]) {
        return;
    }
    
    if ([item isKindOfClass:[NSString class]]) {
        return;
    }
    
    [self setupRightFavorStatus:item.isFavorite];
    // 已有数据，不用请求当前页数据鸟 ~~~
    if (self.dataArray[to] != [NSNull null]) {
        return;
    }
    
    if ([self.request.currentPage intValue] != needPage) {
        [self.request stopRequest];
        self.request = [[YXGetFavorQRequest alloc] init];
        self.request.stageId = self.stageId;
        self.request.sectionId = self.sectionId ? self.sectionId : @"0";
        self.request.subjectId = self.subjectId;
        self.request.beditionId = self.editionId;
        self.request.volumeId = self.volumeId;
        self.request.chapterId = self.chapterId;
        self.request.pageSize = [NSString stringWithFormat:@"%@", @(_pageSize)];
        self.request.currentPage = [NSString stringWithFormat:@"%@", @(needPage)];
        self.request.cellId = self.unitId ? self.unitId : @"0";
        
        if (self.comeFrom == YXSavedExerciseComeFrom_ChapterSectionUnitFavor) {
            self.request.ptype = @"0";
        }
        if (self.comeFrom == YXSavedExerciseComeFrom_APCPointFavor) {
            self.request.beditionId = nil;
            self.request.volumeId = nil;
            
            self.request.ptype = @"2";
        }
        _curPage = needPage - 1;
        @weakify(self);
        [self.request startRequestWithRetClass:[YXIntelligenceQuestionListItem class] andCompleteBlock:^(id retItem, NSError *error) {
            @strongify(self);
            if (error) {
                [self yx_showToast:error.localizedDescription];
                return;
            }
            [self updateDataAfterRequest:retItem];
        }];
    }
}

- (YXSlideViewItemViewBase *)slideView:(YXSlideView *)sender viewForIndex:(NSInteger)index {
    if (index >= [self.dataArray count]) {
        return nil;
    }
    
    if (self.dataArray[index] == [NSNull null]) {
        YXSlideViewItemViewBase *v = [[YXSlideViewItemViewBase alloc] init];
        v.userInteractionEnabled = NO;
        v.backgroundColor = [UIColor clearColor];
        [YXLoadingControl startLoadingWithSuperview:v];
        return v;
    }
    
    if ([self.dataArray[index] isKindOfClass:[NSString class]]) {
        YXSlideViewItemViewBase *v = [[YXSlideViewItemViewBase alloc] init];
        v.userInteractionEnabled = NO;
        v.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        [v addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
        }];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"此题缺失\n但您仍可滑动至下一题";
        return v;
    }

    QAQuestion *data = [self.dataArray objectAtIndex:index];
    if (data.templateType == YXQATemplateSingleChoose) {
        YXQAAnalysisSingleChooseView_Pad *bv = [[YXQAAnalysisSingleChooseView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        return bv;
    }
    if (data.templateType == YXQATemplateMultiChoose) {
        YXQAAnalysisMultiChooseView_Pad *bv = [[YXQAAnalysisMultiChooseView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        return bv;
    }
    if (data.templateType == YXQATemplateYesNo) {
        YXQAAnalysisYesNoView_Pad *bv = [[YXQAAnalysisYesNoView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        return bv;
    }
    if (data.templateType == YXQATemplateFill) {
        YXQAAnalysisFillBlankView_Pad *bv = [[YXQAAnalysisFillBlankView_Pad alloc] init];
        bv.data = data;
        bv.title = self.model.paperTitle;
        bv.bShowTitleState = YES;
        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
        bv.pointClickDelegate = self;
        bv.reportErrorDelegate = self;
        bv.analysisDataDelegate = self.analysisDataDelegate;
        return bv;
    }
//    if (data.itemType == YXQAItemMaterial) {
//        YXQAAnalysisMaterialView_Pad *bv = [[YXQAAnalysisMaterialView_Pad alloc] init];
//        bv.data = (YXQAComplexItem *)data;
//        bv.title = self.model.title;
//        bv.canDoExerciseFromKnp = self.canDoExerciseFromKnp;
//        bv.pointClickDelegate = self;
//        bv.reportErrorDelegate = self;
//        bv.analysisDataDelegate = self.analysisDataDelegate;
//        if (index == self.firstLevel) {
//            if (self.secondLevel >= 0) {
//                bv.nextLevelStartIndex = self.secondLevel;
//                self.secondLevel = -1;
//            }
//        }
//        return bv;
//    }
    return nil;
}

#pragma mark - 
- (YXPType)jixXiType
{
    return YXPTypeExerciseHistory;
}

#pragma mark - deprecated

/**
 *  逐个删除 (no use anymore)
 */
- (void)deleteCurrentQuestion {
    QAQuestion *item = [self.dataArray objectAtIndex:self.slideView.selectedIndex];
    if ([item isKindOfClass:[NSNull class]]) {
        return;
    }
    
    if ([item isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (item.isFavorite) {
        @weakify(self);
        [self yx_startLoading];
        [self.delRequest stopRequest];
        self.delRequest = [[YXDeleteFavorRequest alloc] init];
        self.delRequest.questionId = item.questionID;
        [self.delRequest startRequestWithRetClass:[HttpBaseRequestItem class]
                                 andCompleteBlock:^(id retItem, NSError *error) {
                                     @strongify(self); if (!self) return;
                                     for (UIBarButtonItem *item in self.navigationItem.rightBarButtonItems) {
                                         item.enabled = YES;
                                     }
                                     [self yx_stopLoading];
                                     if (error) {
                                         if (!retItem) {
                                             [self yx_showToast:error.localizedDescription];
                                         }
                                         return;
                                     }
                                     // v1.2 数据库
                                     [[[YXSavedExercisesDatabaseManager alloc] init] cleanExercise:item.questionID];
                                     //                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"change favor" object:nil userInfo:nil];
                                     [self setupRightFavorStatus:NO];
                                     item.isFavorite = NO;
                                 }];
    } else {
        [_addFavorRequest stopRequest];
        _addFavorRequest = [[YXAddFavorRequest alloc] init];
        _addFavorRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
        _addFavorRequest.subjectId = self.subjectId;
        _addFavorRequest.beditionId = self.editionId;
        _addFavorRequest.volumeId = self.volumeId;
        _addFavorRequest.chapterId = self.chapterId;
        _addFavorRequest.sectionId = self.sectionId ? self.sectionId : @"0";
        _addFavorRequest.questionId = item.questionID;
        
        _addFavorRequest.cellId = self.unitId ? self.unitId : @"0";
        if (self.comeFrom == YXSavedExerciseComeFrom_ChapterSectionUnitFavor) {
            _addFavorRequest.ptype = @"0";
        }
        if (self.comeFrom == YXSavedExerciseComeFrom_APCPointFavor) {
            _addFavorRequest.beditionId = nil;
            _addFavorRequest.volumeId = nil;
            _addFavorRequest.ptype = @"2";
        }
        [self yx_startLoading];
        [_addFavorRequest startRequestWithRetClass:[HttpBaseRequestItem class]
                                  andCompleteBlock:^(id retItem, NSError *error) {
                                      [self yx_stopLoading];
                                      if (error) {
                                          [self yx_showToast:error.localizedDescription];
                                          return;
                                      }
                                      // v1.2 不用存，等到返回时存储
                                      [self setupRightFavorStatus:YES];
                                      //                                 [[NSNotificationCenter defaultCenter] postNotificationName:@"change favor" object:nil userInfo:nil];
                                      item.isFavorite = YES;
                                  }];
    }
}

#pragma mark - Pad
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

@end

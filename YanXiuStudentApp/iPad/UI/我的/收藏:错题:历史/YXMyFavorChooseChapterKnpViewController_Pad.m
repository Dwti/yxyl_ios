//
//  YXMyFavorChooseChapterKnpViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyFavorChooseChapterKnpViewController_Pad.h"
#import "YXExerciseFavoriteCell.h"
#import "YXGetEditionsRequest.h"
#import "YXSplitViewController.h"
#import "YXMyFavorQAViewController_Pad.h"
@interface YXMyFavorChooseChapterKnpViewController_Pad ()

@property (nonatomic, assign) BOOL isCache;  //是否为收藏缓存

@end

@implementation YXMyFavorChooseChapterKnpViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXFavorChangedNotification object:nil] subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        [self reloadDataAfterDelete];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"我的背景-Pad"];
    bgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (YXExerciseListParams *)listParams
{
    YXExerciseListParams *params = [super listParams];
    params.type = YXExerciseListTypeFavorite;
    return params;
}

#pragma mark - YXExerciseListViewDelegate

- (Class)cellClass
{
    return [YXExerciseFavoriteCell class];
}

- (void)requestVolumeListWithCompletion:(YXVolumeListRespBlock)completion
{
    NSArray *volumeItem = self.subject.children;
    YXNodeElement *volume = nil;
    if (volumeItem.count > 0) {
        volume = volumeItem[0];
    }
    if (completion) {
        completion(volumeItem, volume, [self.subject.data hasKnp], nil);
    }
}

- (void)deleteVolumeWithId:(NSString *)vid
                completion:(void (^)(NSArray *, YXNodeElement *))completion
{
    NSArray *volumeItem = [YXGetEditionsManager deleteVolumeWithVolumeItem:self.subject.children volumeId:vid];
    self.subject.children = (NSArray<YXNodeElement, Optional> *)volumeItem;
    YXNodeElement *volume = nil;
    if (volumeItem.count > 0) {
        volume = volumeItem[0];
    }
    if (completion) {
        completion(volumeItem, volume);
    }
}

- (void)requestExerciseListWithCompletion:(YXExerciseListRespBlock)completion
{
    @weakify(self);
    [[YXExerciseListManager sharedInstance] requestListWithParams:[self listParams] completion:^(YXExerciseListModel *model, BOOL isCache, NSError *error) {
        @strongify(self); if (!self) return;
        self.isCache = isCache;
        if (completion) {
            completion(model, error);
        }
    }];
}

- (void)showQuestionWithChapter:(YXNodeElement *)chapter
                        section:(YXNodeElement *)section
                           cell:(YXNodeElement *)cell
{
    YXNodeElement *raw = nil;
    int favoriteNum = [chapter.data.favoriteNum intValue];
    raw = chapter;
    
    if ([section.data.favoriteNum intValue]) {
        favoriteNum = [section.data.favoriteNum intValue];
        raw = section;
    }
    if ([cell.data.favoriteNum intValue]) {
        favoriteNum = [cell.data.favoriteNum intValue];
        raw = cell;
    }
    
    if (favoriteNum <= 0) { // 无错题，不进入
        return;
    }
    
    YXExerciseListParams *params = [self listParams];
    YXMyFavorQAViewController_Pad *vc = [[YXMyFavorQAViewController_Pad alloc] init];
    if (params.segment == YXExerciseListSegmentChapter) {
        vc.comeFrom = YXSavedExerciseComeFrom_ChapterSectionUnitFavor;
    }
    if (params.segment == YXExerciseListSegmentTestItem) {
        vc.comeFrom = YXSavedExerciseComeFrom_APCPointFavor;
    }
    vc.total = favoriteNum;
    vc.bDataFromDB = self.isCache;
    
    vc.rawModel = raw;
    
    vc.stageId = params.stageId;
    vc.subjectId = params.subjectId;
    vc.editionId = params.editionId;
    vc.volumeId = params.volumeId;
    vc.chapterId = chapter.eid;
    vc.sectionId = section.eid;
    vc.unitId = cell.eid;
    [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
}

- (void)showQuestionWithKnpL0:(YXNodeElement *)knpL0
                        knpL1:(YXNodeElement *)knpL1
                        knpL2:(YXNodeElement *)knpL2
{
    [self showQuestionWithChapter:knpL0
                          section:knpL1
                             cell:knpL2];
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

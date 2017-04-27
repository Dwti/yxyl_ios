//
//  YXExerciseMistakeViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/10/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyMistakeChooseChapterKnpViewController_Pad.h"
#import "YXExerciseMistakeCell.h"
#import "YXGetEditionsRequest.h"
#import "YXSplitViewController.h"
#import "YXCuoTiViewController_Pad.h"
@interface YXMyMistakeChooseChapterKnpViewController_Pad ()

@property (nonatomic, assign) BOOL isCache;  //是否为错题缓存

@end

@implementation YXMyMistakeChooseChapterKnpViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    @weakify(self);
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"delete 错题" object:nil] subscribeNext:^(id x) {
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
    params.type = YXExerciseListTypeMistake;
    return params;
}

#pragma mark - YXExerciseListViewDelegate

- (Class)cellClass
{
    return [YXExerciseMistakeCell class];
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
    int wrongNumber = [chapter.data.wrongNum intValue];
    raw = chapter;

    if ([section.data.wrongNum intValue]) {
        wrongNumber = [section.data.wrongNum intValue];
        raw = section;
    }
    if ([cell.data.wrongNum intValue]) {
        wrongNumber = [cell.data.wrongNum intValue];
        raw = cell;
    }
    
    if (wrongNumber <= 0) { // 无错题，不进入
        return;
    }
    YXExerciseListParams *params = [self listParams];
    YXCuoTiViewController_Pad *vc = [[YXCuoTiViewController_Pad alloc] init];
    vc.comeFrom = YXSavedExerciseComeFrom_ChapterSectionUnitCuoti;
    vc.total = wrongNumber;
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
    YXNodeElement *raw = nil;
    int wrongNumber = [knpL0.data.wrongNum intValue];
    raw = knpL0;
    
    if ([knpL1.data.wrongNum intValue]) {
        wrongNumber = [knpL1.data.wrongNum intValue];
        raw = knpL1;
    }
    if ([knpL2.data.wrongNum intValue]) {
        wrongNumber = [knpL2.data.wrongNum intValue];
        raw = knpL2;
    }
    
    if (wrongNumber <= 0) { // 无错题，不进入
        return;
    }
    
    YXExerciseListParams *params = [self listParams];
    YXCuoTiViewController_Pad *vc = [[YXCuoTiViewController_Pad alloc] init];
    vc.comeFrom = YXSavedExerciseComeFrom_APCPointCuoti;
    vc.total = wrongNumber;
    vc.bDataFromDB = self.isCache;
    
    vc.rawModel = raw;
    
    vc.stageId = params.stageId;
    vc.subjectId = params.subjectId;
    vc.editionId = params.editionId;
    vc.chapterId = knpL0.eid;
    vc.sectionId = knpL1.eid;
    vc.unitId = knpL2.eid;
    
    [self.yxSplitViewController.navigationController pushViewController:vc animated:YES];
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

//
//  YXExerciseMistakeViewController_Pad_NewViewController.m
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/6/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXExerciseMistakeViewController_Pad.h"
#import "YXErrorsPagedListFetcher.h"
#import "YXErrorTableViewCell.h"
#import "YXIntelligenceQuestionListItem.h"
#import "YXCuoTiViewController_Pad.h"
#import "YXErrorsRequest.h"
#import "YXErrorsManager.h"
#import "YXDelMistakeRequest.h"
#import "YXExerciseTreeView.h"

@interface YXExerciseMistakeViewController_Pad ()
<
UITableViewDelegate
,YXErrorTableViewCellDelegate
,YXHtmlCellHeightDelegate
>

@property (nonatomic, strong) UIView *topContainerView;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) NSMutableArray *heightArray;
@property (nonatomic, strong) YXDelMistakeRequest *delRequest;
@property (nonatomic, strong) YXExerciseTreeView *treeView;
@property (nonatomic, assign) BOOL isCache;

@end

@implementation YXExerciseMistakeViewController_Pad

#pragma mark- Get
- (YXExerciseTreeView *)treeView
{
    if (!_treeView) {
        _treeView = [[YXExerciseTreeView alloc] initWithFrame:CGRectZero];
//        self.treeView.delegate = self;
        _treeView.backgroundColor = [UIColor clearColor];
        _treeView.comeFromKnp = (self.listParams.segment == YXExerciseListSegmentTestItem);
    }
    return _treeView;
}

- (NSMutableArray *)heightArray
{
    if (!_heightArray) {
        _heightArray = [NSMutableArray new];
    }
    return _heightArray;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [UIImageView new];
        _bgImageView.image = [UIImage imageNamed:@"背景01"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}

- (UILabel *)totalLabel
{
    if (!_totalLabel) {
        _totalLabel           = [UILabel new];
        _totalLabel.textColor = [UIColor colorWithRGBHex:0xffdb4d];
        _totalLabel.font      = [UIFont boldSystemFontOfSize:19];
        [_totalLabel yx_setShadowWithColor:[UIColor colorWithRGBHex:0x005959]];
    }
    return _totalLabel;
}
- (UIView *)topContainerView
{
    if (!_topContainerView) {
        _topContainerView= [[UIView alloc] init];
        _topContainerView.backgroundColor = [UIColor colorWithHexString:@"008080"];
        _topContainerView.clipsToBounds = YES;
        UIView *sepView = [[UIView alloc] init];
        sepView.backgroundColor = [UIColor colorWithHexString:@"007373"];
        [self.topContainerView addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(2);
        }];
        
        [_topContainerView addSubview:self.totalLabel];
        [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.centerY.offset = 0;
        }];
        
    }
    return _topContainerView;
}

- (PagedListFetcherBase *)dataFetcher
{
    if (!_dataFetcher) {
        YXErrorsPagedListFetcher *dataFetcher = [[YXErrorsPagedListFetcher alloc] init];
        dataFetcher.subjectId                 = self.subject.eid;
        YXExerciseListParams *params      = [self listParams];
        dataFetcher.stageId                   = params.stageId;
        @weakify(self)
        [dataFetcher setError:^(NSError *error) {
            @strongify(self)
            [self yx_showToast:@"网络错误，加载缓存"];
            if (self.dataFetcher.pageindex == 0) {
                [self.dataArray removeAllObjects];
            }
            
//            self.total = [YXErrorsManager errorTotal];
            _isCache = YES;
//            [self.dataArray addObjectsFromArray:[YXErrorsManager errorsWithPageSize:self.dataFetcher.pagesize page:self.dataFetcher.pageindex]];
            _isCache = NO;
            [self yx_stopLoading];
            [self checkHasMore];
            [self stopAnimation];
            [self.tableView reloadData];
        }];
        _dataFetcher = dataFetcher;
    }
    return _dataFetcher;
}

#pragma mark- Set
- (void)setTotal:(long)total
{
    _total = total;
    self.totalLabel.text      = [NSString stringWithFormat:@"全部%ld题", _total];
    NSLog(@"%@", self.totalLabel.text);
}

#pragma mark- Masonry
- (void)addMasonry
{
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topContainerView.mas_bottom).offset = 20;
        make.left.right.bottom.offset = 0;
    }];
    
    [self.topContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(58);
    }];
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.treeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topContainerView.mas_bottom);
        //make.bottom.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.leftRightGapForTreeView);
        make.right.mas_equalTo(-self.leftRightGapForTreeView);
    }];
}

#pragma mark-
- (void)loadView
{
    [super loadView];
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.topContainerView];
}

- (void)viewDidLoad {
    [self.view addSubview:self.treeView];
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self yx_setupLeftBackBarButtonItem];
    self.title = self.subject.name;
//    self.treeView.hidden = YES;
    [self addMasonry];
    
    [self.tableView registerClass:[YXErrorTableViewCell class] forCellReuseIdentifier:@"YXQAQuestionCell2"];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [self firstPageFetch];
    
    WEAK_SELF
    [[[self.dataArray rac_signalForSelector:@selector(addObjectsFromArray:)] map:^id(id value) {
        return [value first];
    }] subscribeNext:^(NSArray *array) {
        STRONG_SELF
        self.totalLabel.text      = [NSString stringWithFormat:@"全部%ld题", self.total];
        if (!_isCache) {
//            [YXErrorsManager saveErrors:array];
        }
        for (QAQuestion *item in array) {
            [self.heightArray addObject:@([YXErrorTableViewCell heightForString:item.stem dashHidden:NO])];
        }
    }];
    
    [self aspect_hookSelector:@selector(morePageFetch) withOptions:AspectPositionBefore usingBlock:^(){
        STRONG_SELF
        if (self.dataArray.count) {
            QAQuestion *item = self.dataArray.lastObject;
            ((YXErrorsPagedListFetcher *)self.dataFetcher).currentId = item.testID;
        }
    } error:nil];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXDELETEERROR object:nil] subscribeNext:^(NSNotification *notification) {
        STRONG_SELF
        QAQuestion *item = notification.object;
        [YXErrorsManager deleteError:item];
        --self.total;
        NSInteger index        = [self.dataArray indexOfObject:item];
        if (index > self.dataArray.count || index < 0) {
            return;
        }
        [self.dataArray removeObject:item];
        [self.heightArray removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if (self.total == 0) {
            [self firstPageFetch];
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-
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
    vc.isCache = ((YXErrorsPagedListFetcher *)self.dataFetcher).isCache;

    vc.comeFrom = YXSavedExerciseComeFrom_ChapterSectionUnitCuoti;
    vc.total = wrongNumber;
    //应该是数据库，先注掉
    //    vc.bDataFromDB = self.isCache;
    
    vc.rawModel = raw;
    
    vc.stageId = params.stageId;
    vc.subjectId = params.subjectId;
    vc.editionId = params.editionId;
    vc.volumeId = params.volumeId;
    vc.chapterId = chapter.eid;
    vc.sectionId = section.eid;
    vc.unitId = cell.eid;
    QAPaperModel *model = [QAPaperModel new];
    model.questions = self.dataArray;
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (YXExerciseListParams *)listParams
{
    YXExerciseListParams *params = [[YXExerciseListParams alloc] init];
    params.stageId = [YXUserManager sharedManager].userModel.stageid;
    params.subjectId = self.subject.eid;
    params.editionId = self.subject.data.editionId;
    params.volumeId = self.subject.eid;
    //    params.segment = self.segment;
    return params;
}


#pragma mark - table view
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.heightArray[indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YXQAQuestionCell2"];
    cell.dashLineHidden        = YES;
    cell.item                  = self.dataArray[indexPath.row];
    cell.delegate              = self;
    cell.showSeparator         = indexPath.row < self.dataArray.count - 1;
    return cell;
}

#pragma mark- YXErrorTableViewCellDelegate
- (void)deleteItem:(QAQuestion *)item
{
    @weakify(self);
    [self yx_startLoading];
    [self.delRequest stopRequest];
    self.delRequest = [[YXDelMistakeRequest alloc] init];
    self.delRequest.questionId = item.questionID;
    [self.delRequest startRequestWithRetClass:[HttpBaseRequestItem class]
                             andCompleteBlock:^(id retItem, NSError *error) {
                                 @strongify(self);
                                 if (error && error.code != 69) {//69是已经删除成功了
                                     [self yx_stopLoading];
                                     if (!retItem) {
                                         [self yx_showToast:error.localizedDescription];
                                     }
                                     return;
                                 }
                                 
                                 [[NSNotificationCenter defaultCenter] postNotificationName:YXDELETEERROR object:item userInfo:nil];
                                 [self yx_stopLoading];
                                 
                             }];
}

#pragma mark- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXExerciseListParams *params = [self listParams];
    YXCuoTiViewController_Pad *vc = [[YXCuoTiViewController_Pad alloc] init];
    vc.comeFrom = YXSavedExerciseComeFrom_ChapterSectionUnitCuoti;
    vc.total = [self.subject.data wrongNum].integerValue;
    vc.index = indexPath.row;
    //应该是数据库，先注掉
    //    vc.bDataFromDB = self.isCache;
    
    vc.rawModel = self.subject;
    vc.pageSize = self.dataFetcher.pagesize;
    vc.curPage = (int)indexPath.row / self.dataFetcher.pagesize;
    
    vc.stageId   = params.stageId;
    vc.subjectId = params.subjectId;
    vc.editionId = params.editionId;
    vc.volumeId  = params.volumeId;
    vc.dataArray = self.dataArray;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - height delegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    if (!ip) {
        return;
    }
    
    CGFloat h = [_heightArray[ip.row] floatValue];
    CGFloat nh = ceilf(height);
    
    if (h != nh) {
        [self.heightArray replaceObjectAtIndex:ip.row withObject:@(nh)];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView layoutIfNeeded];
    }
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end

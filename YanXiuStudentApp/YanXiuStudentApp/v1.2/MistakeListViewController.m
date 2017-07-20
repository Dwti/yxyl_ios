//
//  MistakeAllViewController.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/27/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeListViewController.h"
#import "YXErrorsPagedListFetcher.h"
#import "YXErrorTableViewCell.h"
#import "YXIntelligenceQuestionListItem.h"
#import "YXMistakeContentViewController.h"
#import "MistakeQuestionManager.h"
#import "MistakeRedoViewController.h"
#import "YXMistakeContentChapterKnpViewController.h"

static NSString *errorTableViewCell = @"errorTableViewCell";

@interface MistakeListViewController () <
UITableViewDelegate,
UITableViewDataSource,
YXErrorTableViewCellDelegate,
YXHtmlCellHeightDelegate
>
@property (nonatomic, strong) NSMutableArray *heightMutableArray;
@property (nonatomic, strong) MistakeRedoNumItem *numItem;
@property (nonatomic, assign) BOOL isUpdatingRedoNumber;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) PagedListFetcherBase *fetcher;
@end

@implementation MistakeListViewController

- (instancetype)initWithFetcher:(PagedListFetcherBase *)fetcher {
    if (self = [super init]) {
        self.fetcher = fetcher;
    }
    return self;
}

- (void)viewDidLoad {
    self.dataFetcher = self.fetcher;
    self.heightMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    [super viewDidLoad];
    self.title = self.subject.name;
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
    [self addNotification];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[YXErrorTableViewCell class] forCellReuseIdentifier:errorTableViewCell];
}

#pragma mark - notification
- (void)addNotification {
    WEAK_SELF
    [[[self.dataArray rac_signalForSelector:@selector(addObjectsFromArray:)] map:^id(id value) {
        return [value first];
    }] subscribeNext:^(NSArray *array) {
        STRONG_SELF
        [self.heightMutableArray addObjectsFromArray:[[[array rac_sequence] map:^id(QAQuestion *item) {
            return @([YXErrorTableViewCell heightForString:[item stemForMistake]]);
        }] array]];
    }];
    
    [[self.dataArray rac_signalForSelector:@selector(removeAllObjects)] subscribeNext:^(id x) {
        STRONG_SELF
        [self.heightMutableArray removeAllObjects];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:kDeleteMistakeSuccessNotification object:nil] subscribeNext:^(NSNotification *notification) {
        STRONG_SELF
        [self getMistakeRedoQuestionNumber];
        NSArray *deletedIDs = notification.object;
        [self deleteQuestionsByID:deletedIDs];
    }];
}

- (void)deleteQuestionsByID:(NSArray *)idArray {
    self.total -= idArray.count;
    
    NSMutableArray *removedIndexPaths = [NSMutableArray array];
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *question = obj;
        for (NSString *qID in idArray) {
            if ([question.wrongQuestionID isEqualToString:qID]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [removedIndexPaths addObject:indexPath];
            }
        }
    }];
    
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSIndexPath *indexPath in removedIndexPaths) {
        [indexSet addIndex:indexPath.row];
    }
    [self.heightMutableArray removeObjectsAtIndexes:indexSet];
    [self.dataArray removeObjectsAtIndexes:indexSet];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:removedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
    
    if (self.dataArray.count == 0) {
        [self firstPageFetch];
    }
}

#pragma mark - Redo Number
- (void)getMistakeRedoQuestionNumber {
//    self.isUpdatingRedoNumber = YES;
//    WEAK_SELF
//    [[MistakeQuestionManager sharedInstance] requestMistakeRedoNumWithSubjectId:self.subject.subjectID completeBlock:^(MistakeRedoNumItem *item, NSError *error) {
//        STRONG_SELF
//        [self yx_stopLoading];
//        self.isUpdatingRedoNumber = NO;
//        if (error) {
//            [self yx_showToast:error.localizedDescription];
//            [self updateRedoButtonForError];
//            return;
//        }
//        self.numItem = item;
//        [self updateRedoNum:item];
//    }];
}

- (void)updateRedoButtonForError {
    [self.redoButton setTitle:@"错题重做" forState:UIControlStateNormal];
    self.redoButton.alpha = 1.0;
    self.redoButton.userInteractionEnabled = YES;
    [self.redoButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮"] forState:UIControlStateNormal];
    [self.redoButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮-按下"] forState:UIControlStateHighlighted];
}

- (void)updateRedoNum:(MistakeRedoNumItem *)item{
    NSString *redoNum = item.property.questionNum;
    if (isEmpty(redoNum)) {
        redoNum = @"0";
    }
    NSString *title = [NSString stringWithFormat:@"错题重做 (%@)", redoNum];
    [self.redoButton setTitle:title forState:UIControlStateNormal];
    
    if (item.property.questionNum.integerValue == 0) {
        self.redoButton.alpha = 0.4;
        self.redoButton.userInteractionEnabled = NO;
        [self.redoButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"按钮不可点击"] forState:UIControlStateNormal];
    } else {
        self.redoButton.alpha = 1.0;
        self.redoButton.userInteractionEnabled = YES;
        [self.redoButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮"] forState:UIControlStateNormal];
        [self.redoButton setBackgroundImage:[UIImage yx_resizableImageNamed:@"黄按钮-按下"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - Set
- (void)setTotal:(long)total {
    _total = total;
    self.totalLabel.text = [NSString stringWithFormat:@"全部%ld题", _total];
    
    [self getMistakeRedoQuestionNumber];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.heightMutableArray[indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.heightMutableArray[indexPath.row] floatValue];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.chapter_point_title) {
        YXMistakeContentChapterKnpViewController *vc = [[YXMistakeContentChapterKnpViewController alloc] init];
        vc.total = self.total;
        vc.index = indexPath.row;
        vc.subject = self.subject;
        vc.pageSize = self.dataFetcher.pagesize;
        vc.curPage = (int)indexPath.row / self.dataFetcher.pagesize;
        QAPaperModel *model = [[QAPaperModel alloc] init];
        model.questions = self.dataArray;
        vc.model = model;
        vc.fetcher = (MistakePageListFetcher *)self.fetcher;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    YXErrorsPagedListFetcher *currentFetcher = (YXErrorsPagedListFetcher *)self.fetcher;
    YXErrorsPagedListFetcher *fetcher = [[YXErrorsPagedListFetcher alloc]init];
    fetcher.subjectID = currentFetcher.subjectID;
    fetcher.stageID = currentFetcher.stageID;
    fetcher.lastID = currentFetcher.lastID;
    fetcher.pageindex = currentFetcher.pageindex;
    YXMistakeContentViewController *vc = [[YXMistakeContentViewController alloc] initWithFetcher:fetcher];
    vc.total = self.total;
    vc.index = indexPath.row;
    vc.subject = self.subject;
    QAPaperModel *model = [[QAPaperModel alloc] init];
    model.questions = self.dataArray;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:errorTableViewCell];
    cell.item = self.dataArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - height delegate
- (void)tableViewCell:(UITableViewCell *)cell updateWithHeight:(CGFloat)height {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    if (ip) {
        CGFloat h = [self.heightMutableArray[ip.row] floatValue];
        CGFloat nh = ceilf(height);
        if (h != nh) {
            [self.heightMutableArray replaceObjectAtIndex:ip.row withObject:@(nh)];
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
            [self.tableView layoutIfNeeded];
        }
    }
}


#pragma mark- YXErrorTableViewCellDelegate
- (void)deleteItem:(QAQuestion *)item {
    WEAK_SELF
    [self yx_startLoading];
    [[MistakeQuestionManager sharedInstance]deleteMistakeQuestion:item completeBlock:^(NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        }
        [self getMistakeRedoQuestionNumber];
    }];
}


#pragma mark - Actions
- (void)redoButtonTapped {
    if (self.isUpdatingRedoNumber || !self.numItem) {
        WEAK_SELF
        [self yx_startLoading];
        [[MistakeQuestionManager sharedInstance] requestMistakeRedoNumWithSubjectId:self.subject.subjectID completeBlock:^(MistakeRedoNumItem *item, NSError *error) {
            STRONG_SELF
            self.isUpdatingRedoNumber = NO;
            if (error) {
                [self yx_stopLoading];
                [self yx_showToast:error.localizedDescription];
                return;
            }
            self.numItem = item;
            [self updateRedoNum:item];
            [self fetchRedoFirstData];
        }];
    }else {
        [self fetchRedoFirstData];
    }
}

- (void)fetchRedoFirstData {
    WEAK_SELF
    [[MistakeQuestionManager sharedInstance] requestMistakeRedoFirstWithSubjectID:self.subject.subjectID completeBlock:^(QAPaperModel *model, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        [self gotoRedoVCWithModel:model];
    }];
}

- (void)gotoRedoVCWithModel:(QAPaperModel *)model {
    MistakeRedoViewController *vc = [[MistakeRedoViewController alloc]init];
    vc.model = model;
    vc.totalNumber = self.numItem.property.questionNum.integerValue;
    vc.subject = self.subject;
    WEAK_SELF
    [vc setUpdateNumberBlock:^(NSInteger num) {
        STRONG_SELF
        self.numItem.property.questionNum = [NSString stringWithFormat:@"%@",@(num)];
        [self updateRedoNum:self.numItem];
    }];
    
    [vc setUpdateNoteBlock:^(NSArray *updatedQuestions) {
        STRONG_SELF
        [self updateNote:updatedQuestions];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updateNote:(NSArray *)updatedQuestions {
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        QAQuestion *question = obj;
        for (QAQuestion *q in updatedQuestions) {
            if ([question.questionID isEqualToString:q.questionID]) {
                [self.dataArray replaceObjectAtIndex:idx withObject:q];
            }
        }
    }];
}


@end

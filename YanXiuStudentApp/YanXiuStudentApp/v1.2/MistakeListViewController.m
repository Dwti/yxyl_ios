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
@property (nonatomic, strong) PagedListFetcherBase *fetcher;
@end

@implementation MistakeListViewController

- (instancetype)initWithFetcher:(PagedListFetcherBase *)fetcher {
    if (self = [super init]) {
        self.fetcher = fetcher;
        self.isShowTip = YES;
    }
    return self;
}

- (void)viewDidLoad {
    self.dataFetcher = self.fetcher;
    self.heightMutableArray = [[NSMutableArray alloc] initWithCapacity:10];
    [super viewDidLoad];
    self.title = self.chapter_point_title;
    self.naviTheme = NavigationBarTheme_White;
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.emptyView.title = @"真棒！还没有错题哦";
    self.emptyView.image = [UIImage imageNamed:@"无错题插图"];
    [self setupUI];
    [self addNotification];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.tableView.tableHeaderView = headerView;
    [self.tableView registerClass:[YXErrorTableViewCell class] forCellReuseIdentifier:errorTableViewCell];
    
    UIButton *redoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 72, 34)];
    [redoButton setTitle:@"错题重做" forState:UIControlStateNormal];
    [redoButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [redoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [redoButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateHighlighted];
    redoButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    redoButton.layer.cornerRadius = 6;
    redoButton.layer.borderWidth = 2;
    redoButton.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    redoButton.clipsToBounds = YES;
    WEAK_SELF
    [[redoButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self redoButtonTapped];
    }];
    self.redoButton = redoButton;
    [self nyx_setupRightWithCustomView:redoButton];
    
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
//            if ([question.wrongQuestionID isEqualToString:qID]) {
            if ([question.questionID isEqualToString:qID]) {
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
    
    NSMutableArray *qidMutableArray = [NSMutableArray arrayWithArray:self.qids];
    [self.qids enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSNumber *qid = obj;
        NSString *qidStr = [NSString stringWithFormat:@"%@",qid];
        for (NSString *qID in idArray) {
            if ([qidStr isEqualToString:qID]) {
                [qidMutableArray removeObject:qid];
            }
        }
    }];
    self.qids = qidMutableArray.copy;
    if (self.qids.count == 0) {
        self.redoButton.hidden = YES;
    }else {
        self.redoButton.hidden = NO;
    }
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
    
    YXMistakeContentViewController *vc = [[YXMistakeContentViewController alloc] initWithFetcher:self.fetcher];
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
    [self.view nyx_startLoading];
    [[MistakeQuestionManager sharedInstance]deleteMistakeQuestion:item completeBlock:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        }
    }];
}


#pragma mark - Actions
- (void)redoButtonTapped {
    WEAK_SELF
    NSUInteger length = MIN(10, (self.qids.count - 0 * 10));
    NSUInteger loc = 0 * 10;
    NSArray *qids = [self.qids subarrayWithRange:NSMakeRange(loc, length)];
    NSString *qidsStr = [qids componentsJoinedByString:@","];
    [self.view nyx_startLoading];
    [[MistakeQuestionManager sharedInstance] requestMistakeRedoPageWithSubjectID:self.subject.subjectID qid:qidsStr completeBlock:^(QAPaperModel *model, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self gotoRedoVCWithModel:model];
    }];
}

- (void)gotoRedoVCWithModel:(QAPaperModel *)model {
    MistakeRedoViewController *vc = [[MistakeRedoViewController alloc]init];
    vc.model = model;
    vc.qids = self.qids;
//    vc.totalNumber = self.numItem.property.questionNum.integerValue;
    vc.subject = self.subject;
    WEAK_SELF
//    [vc setUpdateNumberBlock:^(NSInteger num) {
//        STRONG_SELF
//        self.numItem.property.questionNum = [NSString stringWithFormat:@"%@",@(num)];
//        [self updateRedoNum:self.numItem];
//    }];
    
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

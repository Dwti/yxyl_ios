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
    [self setupUI];
    [self addNotification];
}

- (void)setupUI {
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView registerClass:[YXErrorTableViewCell class] forCellReuseIdentifier:errorTableViewCell];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-81);
    }];
    
    self.redoButton = [[UIButton alloc] init];
    self.redoButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.redoButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    [self.redoButton addTarget:self action:@selector(redoButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.redoButton];
    [self.redoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(275);
        make.height.mas_equalTo(51);
        make.bottom.mas_equalTo(-15);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - notification
- (void)addNotification {
    WEAK_SELF
    [[[self.dataArray rac_signalForSelector:@selector(addObjectsFromArray:)] map:^id(id value) {
        return [value first];
    }] subscribeNext:^(NSArray *array) {
        STRONG_SELF
        [self.heightMutableArray addObjectsFromArray:[[[array rac_sequence] map:^id(QAQuestion *item) {
            return @([YXErrorTableViewCell heightForString:[item stemForMistake] dashHidden:NO]);
        }] array]];
    }];
    
    [[self.dataArray rac_signalForSelector:@selector(removeAllObjects)] subscribeNext:^(id x) {
        STRONG_SELF
        [self.heightMutableArray removeAllObjects];
    }];
    
    [self aspect_hookSelector:@selector(morePageFetch) withOptions:AspectPositionBefore usingBlock:^(){
        STRONG_SELF
        if (self.dataArray.count) {
            if ([self.dataFetcher isKindOfClass:[YXErrorsPagedListFetcher class]]) {
                QAQuestion *item = self.dataArray.lastObject;
                ((YXErrorsPagedListFetcher *)self.dataFetcher).currentID = item.wrongQuestionID;
            }
        }
    } error:nil];
    
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
    self.isUpdatingRedoNumber = YES;
    WEAK_SELF
    [[MistakeQuestionManager sharedInstance] requestMistakeRedoNumWithSubjectId:self.subject.subjectID completeBlock:^(MistakeRedoNumItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        self.isUpdatingRedoNumber = NO;
        if (error) {
            [self yx_showToast:error.localizedDescription];
            [self updateRedoButtonForError];
            return;
        }
        self.numItem = item;
        [self updateRedoNum:item];
    }];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }
    return 0.0000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

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
    
    YXMistakeContentViewController *vc = [[YXMistakeContentViewController alloc] init];
    vc.total = self.total;
    vc.index = indexPath.row;
    vc.subject = self.subject;
    vc.pageSize = self.dataFetcher.pagesize;
    vc.curPage = (int)indexPath.row / self.dataFetcher.pagesize;
    QAPaperModel *model = [[QAPaperModel alloc] init];
    model.questions = self.dataArray;
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXErrorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:errorTableViewCell];
    cell.dashLineHidden = YES;
    cell.item = self.dataArray[indexPath.row];
    cell.delegate = self;
    cell.showSeparator = indexPath.row < self.dataArray.count - 1;
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

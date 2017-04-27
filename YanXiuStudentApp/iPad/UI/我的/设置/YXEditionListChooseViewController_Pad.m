//
//  YXEditionListChooseViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXEditionListChooseViewController_Pad.h"
#import "YXMineSelectCell.h"
#import "YXGetEditionsRequest.h"
#import "YXSaveEditionInfoRequest.h"
#import "YXGetSubjectRequest.h"
#import "YXExerciseEmptyView.h"
#import "YXCommonErrorView.h"

@interface YXEditionListChooseViewController_Pad ()

@property (nonatomic, strong) YXExerciseEmptyView *emptyView;
@property (nonatomic, strong) YXCommonErrorView *errorView;

@property (nonatomic, strong) YXNodeElementListItem *item;
@property (nonatomic, strong) YXSaveEditionInfoRequest *saveRequest;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, assign) NSInteger curIndex;

@end

@implementation YXEditionListChooseViewController_Pad

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"选择%@教材", self.subject.name];
    self.saveButton = [self yx_setupRightButtonItemWithTitle:@"保存" image:nil highLightedImage:nil];
    self.saveButton.enabled = NO;
    [self loadEditions];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    
    _emptyView = [[YXExerciseEmptyView alloc] init];
    _emptyView.hidden = YES;
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    _errorView = [[YXCommonErrorView alloc] init];
    [self.view addSubview:_errorView];
    [_errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _errorView.hidden = YES;
    @weakify(self);
    [_errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self requestEditions];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.saveRequest stopRequest];
}

- (void)loadEditions
{
    self.item = [[YXGetEditionsManager sharedManager] editionsWithSubjectId:self.subject.eid];
    if (self.item) {
        [self.tableView reloadData];
        [self reloadSelectedEdition];
    }
    [self requestEditions];
}

- (void)requestEditions
{
    @weakify(self);
    [self yx_startLoading];
    self.saveButton.enabled = NO;
    [[YXGetEditionsManager sharedManager] requestEditionWithSubjectId:self.subject.eid compeletion:^(YXNodeElementListItem *item, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (item && item.data.count == 0) {
            if (item.status.desc) {
                [self.emptyView setEmptyText:item.status.desc];
            }
            self.tableView.hidden = YES;
            self.emptyView.hidden = NO;
            self.saveButton.enabled = NO;
            return;
        }
        if (error) {
            self.tableView.hidden = YES;
            self.errorView.errorCode = [NSString stringWithFormat:@"%@", @(error.code)];
            self.errorView.hidden = NO;
            self.saveButton.enabled = NO;
            return;
        }
        
        self.item = item;
        self.tableView.hidden = NO;
        self.saveButton.enabled = YES;
        [self.tableView reloadData];
        [self reloadSelectedEdition];
    }];
}

- (void)yx_rightButtonPressed:(id)sender
{
    YXNodeElement *model = self.item.data[self.curIndex];
    if ([self.subject.data.editionId isEqualToString:model.eid]) {
        [self yx_leftBackButtonPressed:nil];
        return;
    }
    
    if (self.saveRequest) {
        [self.saveRequest stopRequest];
    }
    self.saveRequest = [[YXSaveEditionInfoRequest alloc] init];
    self.saveRequest.stageId = [YXUserManager sharedManager].userModel.stageid;
    self.saveRequest.subjectId = self.subject.eid;
    self.saveRequest.beditionId = model.eid;
    @weakify(self);
    [self yx_startLoading];
    self.saveButton.enabled = NO;
    [self.saveRequest startRequestWithRetClass:[HttpBaseRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        self.saveButton.enabled = YES;
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        } else {
            [[YXGetSubjectManager sharedManager] saveSubject:self.subject edition:model];
            [self yx_leftBackButtonPressed:nil];
        }
    }];
}

- (void)reloadSelectedEdition
{
    if (!self.subject.data || !self.item.data) {
        return;
    }
    [self.item.data enumerateObjectsUsingBlock:^(YXNodeElement *edition, NSUInteger idx, BOOL *stop) {
        if ([self.subject.data.editionId isEqualToString:edition.eid]) {
            self.saveButton.enabled = YES;
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            *stop = YES;
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.item.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineSelectCellIdentifier];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    YXNodeElement *edition = self.item.data[indexPath.row];
    [cell setTitle:edition.name image:nil];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.curIndex = indexPath.row;
    self.saveButton.enabled = YES;
}

@end

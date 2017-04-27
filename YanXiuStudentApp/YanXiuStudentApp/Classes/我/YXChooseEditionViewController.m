//
//  YXChooseEditionViewController.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/8/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "YXChooseEditionViewController.h"
#import "YXMineSelectCell.h"
#import "YXExerciseEmptyView.h"
#import "YXCommonErrorView.h"
#import "ExerciseSubjectManager.h"
#import "SaveEditionRequest.h"
@interface YXChooseEditionViewController ()
@property (nonatomic, strong) YXExerciseEmptyView *emptyView;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) GetEditionRequestItem *item;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, assign) NSInteger curIndex;
@end

@implementation YXChooseEditionViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"选择%@教材", self.subject.name];
    [self yx_setupLeftBackBarButtonItem];
    self.saveButton = [self yx_setupRightButtonItemWithTitle:@"保存" image:nil highLightedImage:nil];
    self.saveButton.enabled = NO;
    [self yx_startLoading];
    [self requestEditions];
}
- (void)loadView {
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
- (void)requestEditions {
    @weakify(self);
    [[ExerciseSubjectManager sharedInstance] requestEditionsWithSubjectID:self.subject.subjectID completeBlock:^(GetEditionRequestItem *retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        if (retItem && retItem.editions.count == 0) {
            if (retItem.status.desc) {
                [self.emptyView setEmptyText:retItem.status.desc];
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
        self.item = retItem;
        self.tableView.hidden = NO;
        self.saveButton.enabled = YES;
        [self.tableView reloadData];
        [self reloadSelectedEdition];
    }];
}
- (void)yx_rightButtonPressed:(id)sender {
    GetEditionRequestItem_edition *model = self.item.editions[self.curIndex];
    if ([self.subject.edition.editionId isEqualToString:model.editionID]) {
        [self yx_leftBackButtonPressed:nil];
        return;
    }
    @weakify(self);
    [self yx_startLoading];
    self.saveButton.enabled = NO;
    [[ExerciseSubjectManager sharedInstance] saveEditionWithSubjectID:self.subject.subjectID editionID:model.editionID completeBlock:^(GetSubjectRequestItem_subject *retItem, NSError *error){
        @strongify(self);
        self.saveButton.enabled = YES;
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        }else {
            [self yx_leftBackButtonPressed:nil];
        }
    }];
}
- (void)reloadSelectedEdition {
    if (!self.subject.edition || !self.item.editions) {
        return;
    }
    [self.item.editions enumerateObjectsUsingBlock:^(GetEditionRequestItem_edition *edition, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.subject.edition.editionId isEqualToString:edition.editionID]) {
            self.saveButton.enabled = YES;
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            *stop = YES;
        }
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.editions.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YXMineSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineSelectCellIdentifier];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    GetEditionRequestItem_edition *edition = self.item.editions[indexPath.row];
    [cell setTitle:edition.name image:nil];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.curIndex = indexPath.row;
    self.saveButton.enabled = YES;
}
@end

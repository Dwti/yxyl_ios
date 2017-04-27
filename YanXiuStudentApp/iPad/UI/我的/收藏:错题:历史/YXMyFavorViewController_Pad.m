//
//  YXMyFavorViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by Lei Cai on 9/21/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import "YXMyFavorViewController_Pad.h"
#import "YXMineTableViewCell.h"
#import "YXSubjectImageHelper.h"
#import "UIColor+YXColor.h"
#import "YXGetMistakeEditionRequest.h"
#import "YXCommonErrorView.h"
#import "YXExerciseEmptyView.h"

#import "YXGetFavorEditionRequest.h"
#import "YXMyFavorChooseChapterKnpViewController_Pad.h"

@interface YXMyFavorViewController_Pad () 

@property (nonatomic, strong) YXGetFavorEditionRequest *request;
@property (nonatomic, strong) YXNodeElementListItem *item;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) YXExerciseEmptyView *emptyView;

@end

@implementation YXMyFavorViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的收藏";
    [self getMistakeEdition];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    [self.view addSubview:self.errorView];
    [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.errorView.hidden = YES;
    @weakify(self);
    [self.errorView setRetryBlock:^{
        @strongify(self); if (!self) return;
        [self getMistakeEdition];
    }];
    
    _emptyView = [[YXExerciseEmptyView alloc] init];
    _emptyView.hidden = YES;
    [self.view addSubview:_emptyView];
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXFavorChangedNotification object:nil] subscribeNext:^(id x) {
        @strongify(self); if (!self) return;
        [self getMistakeEdition];
    }];
}

- (void)reloadUI {
    if (self.errorView) {
        [self getMistakeEdition];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.request stopRequest];
}

- (void)getMistakeEdition
{
    self.item = nil;
    [self.tableView reloadData];
    
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXGetFavorEditionRequest alloc] init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXNodeElementListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        YXNodeElementListItem *item = retItem;
        if (item && item.data.count == 0) {
            if (item.status.desc) {
                [self.emptyView setEmptyText:item.status.desc];
            }
            // 去掉透明背景后的数据
            self.item = nil;
            [self.tableView reloadData];
            
            self.emptyView.hidden = NO;
            return;
        }
        if (error) {
            // v1.2 数据库
            
            YXSavedExercisesDatabaseManager *mgr = [[YXSavedExercisesDatabaseManager alloc] init];
            YXNodeElementListItem *dbItem = [mgr generateFavorEditionItemFromDB];
            if (isEmpty(dbItem.data)) {
                // 网络失败、数据库为空
                self.errorView.errorCode = [NSString stringWithFormat:@"%@", @(error.code)];
                self.errorView.hidden = NO;
                return;
            }
            
            // 用数据库
            self.item = dbItem;
            [self.tableView reloadData];
            return;
        }
        
        // 用网络
        self.item = item;
        [[[YXChapterSectionUnitManager alloc] init] updateAndSaveEdition_Volume:retItem];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.item.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    cell.isTextLabelInset = YES;
    cell.showLine = [self showLineAtIndexPath:indexPath];
    YXNodeElement *subject = self.item.data[indexPath.row];
    [cell setTitle:subject.name image:[UIImage imageNamed:[YXSubjectImageHelper myImageNameWithType:[subject.eid integerValue]]]];
    [cell updateWithAccessoryText:subject.data.favoriteNum isBoldFont:YES];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXMyFavorChooseChapterKnpViewController_Pad *vc = [[YXMyFavorChooseChapterKnpViewController_Pad alloc] init];
    vc.subject = self.item.data[indexPath.row];
    vc.leftRightGapForTreeView = 65;
    [self.navigationController pushViewController:vc animated:YES];
}

@end


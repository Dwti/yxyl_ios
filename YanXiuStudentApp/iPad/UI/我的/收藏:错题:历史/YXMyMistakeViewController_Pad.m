//
//  YXMyMistakeViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyMistakeViewController_Pad.h"
#import "YXMineTableViewCell.h"
#import "YXSubjectImageHelper.h"
#import "UIColor+YXColor.h"
#import "YXGetMistakeEditionRequest.h"
#import "YXCommonErrorView.h"
#import "YXExerciseEmptyView.h"

#import "YXExerciseMistakeViewController_Pad.h"

@interface YXMyMistakeViewController_Pad ()

@property (nonatomic, strong) YXGetMistakeEditionRequest *request;
@property (nonatomic, strong) YXNodeElementListItem *item;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) YXExerciseEmptyView *emptyView;

@end

@implementation YXMyMistakeViewController_Pad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的错题";
    
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
    
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:YXDELETEERROR object:nil] subscribeNext:^(id x) {
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
    self.request = [[YXGetMistakeEditionRequest alloc] init];
    self.request.stageId = [YXUserManager sharedManager].userModel.stageid;
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXNodeElementListItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        self.errorView.hidden = YES;
        self.emptyView.hidden = YES;
        self.tableView.hidden = NO;
        YXNodeElementListItem *item = retItem;
        if (item && item.data.count == 0) {
            if (item.status.desc) {
                [self.emptyView setEmptyText:item.status.desc];
            }
            self.emptyView.hidden = NO;
            self.tableView.hidden = YES;
            return;
        }
        if (error) {
            // v1.2 数据库
            
            YXSavedExercisesDatabaseManager *mgr = [[YXSavedExercisesDatabaseManager alloc] init];
            YXNodeElementListItem *dbItem = [mgr generateMistakeEditionItemFromDB];
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
        
        // v1.2 数据库
        [[[YXChapterSectionUnitManager alloc] init] updateAndSaveEdition_Volume:retItem];
        [self.tableView reloadData];
    }];
}

- (NSAttributedString *)attributedTextWithErrorExercisesNum:(NSString *)num
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:num attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:14.f], NSShadowAttributeName: [self textShadow], NSForegroundColorAttributeName: [UIColor yx_colorWithHexString:@"b3476b"]}];
    return attributedText;
}

- (NSShadow *)textShadow
{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0, 1); //垂直投影
    shadow.shadowColor = [UIColor yx_colorWithHexString:@"ffff99"];
    return shadow;
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
    [cell updateWithAccessoryAttributedText:[self attributedTextWithErrorExercisesNum:subject.data.wrongNum]];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YXExerciseMistakeViewController_Pad *vc = [[YXExerciseMistakeViewController_Pad alloc] init];
    vc.subject = self.item.data[indexPath.row];
    vc.leftRightGapForTreeView = 65;
    [self.navigationController pushViewController:vc animated:YES];
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

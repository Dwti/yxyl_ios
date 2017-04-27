//
//  YXSideMenuViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/19.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSideMenuViewController_Pad.h"
#import "YXPersonalInfoCell_Pad.h"
#import "YXExerciseHomeworkFooterView_Pad.h"
#import "YXExerciseHomeworkHeaderView_Pad.h"
#import "YXExerciseHomeworkCell_Pad.h"
#import "YXSideMenuNormalCell_Pad.h"
#import "YXSideMenuNormalHeaderView_Pad.h"
#import "YXSideMenuCopyrightView_Pad.h"
#import "YXSideMenuNaviDateView_Pad.h"

#import "YXUpdateUserInfoRequest.h"
#import "YXUploadHeadImgRequest.h"

#import "YXRedManager.h"

@interface YXSideMenuViewController_Pad ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSString *redNumber;
@property (nonatomic, weak) YXExerciseHomeworkCell_Pad *exerciseHomeworkCell_Pad;
@end

@implementation YXSideMenuViewController_Pad

#pragma mark- NSNotification
- (void)redChanged:(id)sender
{
    self.redNumber = [sender object];
    self.exerciseHomeworkCell_Pad.redNumber = self.redNumber;
}

#pragma mark-
- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:YXRedNotification
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"008080"];
    [self registerNotifications];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 更新练习状态
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setupUI{
    self.tableView = [[UITableView alloc]init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 3));
    }];
    [self.tableView registerClass:[YXPersonalInfoCell_Pad class] forCellReuseIdentifier:@"YXPersonalInfoCell_Pad"];
    [self.tableView registerClass:[YXExerciseHomeworkCell_Pad class] forCellReuseIdentifier:@"YXExerciseHomeworkCell_Pad"];
    [self.tableView registerClass:[YXSideMenuNormalCell_Pad class] forCellReuseIdentifier:@"YXSideMenuNormalCell_Pad"];
    [self.tableView registerClass:[YXExerciseHomeworkFooterView_Pad class] forHeaderFooterViewReuseIdentifier:@"YXExerciseHomeworkFooterView_Pad"];
    [self.tableView registerClass:[YXExerciseHomeworkHeaderView_Pad class] forHeaderFooterViewReuseIdentifier:@"YXExerciseHomeworkHeaderView_Pad"];
    [self.tableView registerClass:[YXSideMenuNormalHeaderView_Pad class] forHeaderFooterViewReuseIdentifier:@"YXSideMenuNormalHeaderView_Pad"];
    
    YXSideMenuCopyrightView_Pad *copyrightView = [[YXSideMenuCopyrightView_Pad alloc]init];
    [self.view addSubview:copyrightView];
    [copyrightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(32);
        make.bottom.mas_equalTo(-8);
        make.height.mas_equalTo(21);
        make.right.mas_equalTo(-40);
    }];
    
    UIView *rightBarView = [[UIView alloc]init];
    rightBarView.backgroundColor = [UIColor colorWithHexString:@"009999"];
    [self.view addSubview:rightBarView];
    [rightBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView.mas_right);
        make.top.right.bottom.mas_equalTo(0);
    }];
    
    UIView *topRightBarView = [[UIView alloc]init];
    topRightBarView.backgroundColor = [UIColor colorWithHexString:@"007373"];
    [self.view addSubview:topRightBarView];
    [topRightBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tableView.mas_right);
        make.top.right.mas_equalTo(0);
        make.height.mas_equalTo(86);
    }];
    
    YXSideMenuNaviDateView_Pad *naviView = [[YXSideMenuNaviDateView_Pad alloc]initWithFrame:CGRectMake(18, 18, 180, 20)];
    [self.navigationController.navigationBar addSubview:naviView];
}

#pragma mark -

- (void)selectIndex:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[self indexPathWithIndex:index] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self sideMenuPadDidSelectIndex:index];
}

- (NSIndexPath *)indexPathWithIndex:(NSInteger)index
{
    NSInteger numberOfSections = [self numberOfSectionsInTableView:self.tableView];
    NSInteger section = 0;
    NSInteger row = 0;
    NSInteger countIndex = 0;
    for (int i = 0; i < numberOfSections; i++) {
        NSInteger rows = [self tableView:self.tableView numberOfRowsInSection:i];
        if (index > (countIndex + rows - 1)) {
            countIndex += rows;
            continue;
        }
        
        section = i;
        row = index - countIndex;
        break;
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

- (NSInteger)indexWithIndexPath:(NSIndexPath *)indexPath
{
    NSInteger numberOfSections = [self numberOfSectionsInTableView:self.tableView];
    NSInteger section = 0;
    NSInteger index = 0;
    while (section < indexPath.section && section < numberOfSections) {
        index += [self tableView:self.tableView numberOfRowsInSection:section];
        section++;
    }
    index = index + indexPath.row;
    return index;
}

- (void)sideMenuPadDidSelectIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sideMenuPadDidSelectIndex:)]) {
        [self.delegate sideMenuPadDidSelectIndex:index];
    }
}

#pragma mark -

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(redChanged:)
                   name:YXRedNotification
                 object:nil];

    [center addObserver:self
               selector:@selector(updateUserInfoSuccess:)
                   name:YXUpdateUserInfoSuccessNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(updateHeadImgSuccess:)
                   name:YXUpdateHeadImgSuccessNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUserInfoSuccess:(NSNotification *)notification
{
    [self reloadUserInfoViewData];
}

- (void)updateHeadImgSuccess:(NSNotification *)notification
{
    [self reloadUserInfoViewData];
}

#pragma mark -

// 更新侧边栏用户信息
- (void)reloadUserInfoViewData
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 1;
    }else if (section == 3){
        return 2;
    }else if (section == 4){
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        YXPersonalInfoCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXPersonalInfoCell_Pad"];
        [cell reloadWithData:[YXUserManager sharedManager].userModel];
        
        return cell;
    }else if (indexPath.section == 1){
        YXExerciseHomeworkCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXExerciseHomeworkCell_Pad"];
        if (indexPath.row == 0) {
            cell.type = YXExercise;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self selectIndex:1];
            });
            cell.redNumber = nil;
        }else{
            cell.type = YXHomework;
            cell.redNumber = self.redNumber;
            self.exerciseHomeworkCell_Pad = cell;
        }
        return cell;
    }else if (indexPath.section == 2){
        YXSideMenuNormalCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSideMenuNormalCell_Pad"];
        cell.type = YXSideMenuRank;
        cell.dashLineHidden = YES;
        return cell;
    }else if (indexPath.section == 3){
        YXSideMenuNormalCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSideMenuNormalCell_Pad"];
//        if (indexPath.row == 0) {
//            cell.type = YXSideMenuFavor;
//            cell.dashLineHidden = NO;
//        }else
        if (indexPath.row == 0){
            cell.type = YXSideMenuMistake;
            cell.dashLineHidden = NO;
        }else if (indexPath.row == 1){
            cell.type = YXSideMenuHistory;
            cell.dashLineHidden = YES;
        }
        return cell;
    }else if (indexPath.section == 4){
        YXSideMenuNormalCell_Pad *cell = [tableView dequeueReusableCellWithIdentifier:@"YXSideMenuNormalCell_Pad"];
        cell.type = YXSideMenuSetting;
        cell.dashLineHidden = YES;
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 86;
    }else if (indexPath.section == 1){
        return 55;
    }else if (indexPath.section == 2){
        return 55;
    }else if (indexPath.section == 3){
        if (indexPath.row != 2) {
            return 52;
        }else{
            return 55;
        }
    }else if (indexPath.section == 4){
        return 52;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 11;
    }else if (section == 2 || section == 3 || section == 4){
        return 7;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 10;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        YXExerciseHomeworkHeaderView_Pad *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExerciseHomeworkHeaderView_Pad"];
        return header;
    }else if (section == 2 || section == 3 || section == 4){
        YXSideMenuNormalHeaderView_Pad *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXSideMenuNormalHeaderView_Pad"];
        return header;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        YXExerciseHomeworkFooterView_Pad *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"YXExerciseHomeworkFooterView_Pad"];
        return footer;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self sideMenuPadDidSelectIndex:[self indexWithIndexPath:indexPath]];
}

@end

//
//  MineViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MineViewController.h"
#import "MineItemCell.h"
#import "MineTableHeaderView.h"
#import "StageSelectionViewController.h"
#import "MyProfileViewController.h"
#import "YXMistakeSubjectViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MineTableHeaderView *headerView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    [self setupUI];
    [self setupObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navigationController.topViewController != self) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.headerView = [[MineTableHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 153)];
    self.headerView.name = [YXUserManager sharedManager].userModel.realname;
    self.headerView.account = [YXUserManager sharedManager].userModel.mobile;
    self.headerView.headUrl = [YXUserManager sharedManager].userModel.head;
    WEAK_SELF
    [self.headerView setEnterBlock:^{
        STRONG_SELF
        MyProfileViewController *vc = [[MyProfileViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.sectionHeaderHeight = 10;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.tableView registerClass:[MineItemCell class] forCellReuseIdentifier:@"MineItemCell"];
    UIView *v = [[UIView alloc]initWithFrame:CGRectMake(0, -500, SCREEN_WIDTH, 500)];
    v.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
    [self.tableView addSubview:v];
}

- (void)setupObserver {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUpdateUserInfoSuccessNotification object:nil]subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        NSNumber *value = [x.userInfo valueForKey:YXUpdateUserInfoTypeKey];
        YXUpdateUserInfoType type = value.integerValue;
        if (type == YXUpdateUserInfoTypeRealname) {
            self.headerView.name = [YXUserManager sharedManager].userModel.realname;
        }else if (type == YXUpdateUserInfoTypeStage) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:YXUpdateHeadImgSuccessNotification object:nil]subscribeNext:^(NSNotification *x) {
        STRONG_SELF
        self.headerView.headUrl = [YXUserManager sharedManager].userModel.head;
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MineItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineItemCell"];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.title = @"我的错题";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"我的错题icon"];
        }else {
            cell.title = @"练习历史";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"练习历史icon"];
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.title = @"学段";
            cell.subtitle = [YXUserManager sharedManager].userModel.stageName;
            cell.image = [UIImage imageNamed:@"学段icon"];
        }else {
            cell.title = @"教材版本";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"教材版本icon"];
        }
    }else {
        if (indexPath.row == 0) {
            cell.title = @"意见反馈";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"意见反馈icon"];
        }else {
            cell.title = @"设置";
            cell.subtitle = nil;
            cell.image = [UIImage imageNamed:@"设置icon"];
        }
    }
    cell.shouldShowShadow = indexPath.row==1;
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            YXMistakeSubjectViewController *vc = [[YXMistakeSubjectViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
        }
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            StageSelectionViewController *vc = [[StageSelectionViewController alloc]init];
            vc.currentIndex = [YXMineManager indexWithStageId:[YXUserManager sharedManager].userModel.stageid];
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
        }
    }else {
        if (indexPath.row == 0) {
            
        }else {
            
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset > 0) {
        return;
    }
    CGFloat space = ABS(yOffset);
    CGFloat rate = space/80;
    rate = MIN(rate, 1);
    self.headerView.offsetRate = rate;
}

@end

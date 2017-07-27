//
//  SchoolSearchViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SchoolSearchViewController.h"
#import "SchoolSearchBarView.h"
#import "SchoolSearchAreaView.h"
#import "SchoolSearchResultCell.h"


@interface SchoolSearchViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) SchoolSearchBarView *searchView;
@property (nonatomic, strong) YXSchoolSearchRequest *request;
@property (nonatomic, strong) YXSchoolSearchItem *item;
@end

@implementation SchoolSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"选择学校";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupUI];
    [self setupObservers];
    [self searchSchoolWithKeyword:self.searchView.textField.text];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor clearColor].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    SchoolSearchBarView *searchView = [[SchoolSearchBarView alloc]init];
    self.searchView = searchView;
    WEAK_SELF
    [searchView setSearchBlock:^(NSString *text){
        STRONG_SELF
        [self searchSchoolWithKeyword:text];
    }];
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15);
        make.left.mas_equalTo(15*kPhoneWidthRatio);
        make.right.mas_equalTo(-15*kPhoneWidthRatio);
        make.height.mas_equalTo(50);
    }];
    
    SchoolSearchAreaView *areaView = [[SchoolSearchAreaView alloc]initWithProvince:self.currentProvince.name city:self.currentCity.name district:self.currentDistrict.name];
    [self.view addSubview:areaView];
    [areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(searchView.mas_left);
        make.right.mas_equalTo(searchView.mas_right);
        make.top.mas_equalTo(searchView.mas_bottom).mas_offset(13);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 50;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[SchoolSearchResultCell class] forCellReuseIdentifier:@"SchoolSearchResultCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(areaView.mas_bottom).mas_offset(13);
    }];
}

- (void)setupObservers {
    WEAK_SELF
    [[[NSNotificationCenter defaultCenter]rac_addObserverForName:UIKeyboardWillChangeFrameNotification object:nil]subscribeNext:^(id x) {
        STRONG_SELF
        NSNotification *noti = (NSNotification *)x;
        NSDictionary *dic = noti.userInfo;
        NSValue *keyboardFrameValue = [dic valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = keyboardFrameValue.CGRectValue;
        NSNumber *duration = [dic valueForKey:UIKeyboardAnimationDurationUserInfoKey];
        [UIView animateWithDuration:duration.floatValue animations:^{
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, [UIScreen mainScreen].bounds.size.height-keyboardFrame.origin.y, 0);
        }];
    }];
}

- (void)searchSchoolWithKeyword:(NSString *)keyword {
    [self.request stopRequest];
    self.request = [[YXSchoolSearchRequest alloc] init];
    self.request.school = keyword;
    self.request.regionId = self.currentDistrict.did;
    WEAK_SELF
    [self.request startRequestWithRetClass:[YXSchoolSearchItem class] andCompleteBlock:^(id retItem, NSError *error) {
        STRONG_SELF
        self.item = retItem;
        [self.tableView reloadData];
        if (self.item.data.count == 0) {
            // 点击搜索后 才有提示框
            if (!self.searchView.textField.isFirstResponder) {
                [self.view nyx_showToast:@"没有搜索到相应的学校"];
            }
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SchoolSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SchoolSearchResultCell"];
    YXSchool *school = self.item.data[indexPath.row];
    cell.title = school.name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 17;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 17;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    YXSchool *school = self.item.data[indexPath.row];
    [self handleSelectSchool:school];
}

- (void)handleSelectSchool:(YXSchool *)school {
    if (![[YXUserManager sharedManager] isLogin]) {
        BLOCK_EXEC(self.schoolSearchBlock,school);
        [self.navigationController popToViewController:self.baseVC animated:YES];
    }else {
        if ([school.sid isEqualToString:[YXUserManager sharedManager].userModel.schoolid]) {
            [self.navigationController popToViewController:self.baseVC animated:YES];
            return;
        }
        
        NSDictionary *param = @{@"provinceid":self.currentProvince.pid,
                                @"provinceName":self.currentProvince.name,
                                @"cityid":self.currentCity.cid,
                                @"cityName":self.currentCity.name,
                                @"areaid":self.currentDistrict.did,
                                @"areaName":self.currentDistrict.name,
                                };
        WEAK_SELF
        [self nyx_disableRightNavigationItem];
        [self.view nyx_startLoading];
        [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeArea param:param completion:^(NSError *error) {
            STRONG_SELF
            if (error) {
                [self nyx_enableRightNavigationItem];
                [self.view nyx_stopLoading];
                [self.view nyx_showToast:error.localizedDescription];
                return;
            }
            [self updateSchool:school];
        }];
    }
}

- (void)updateSchool:(YXSchool *)school {
    NSMutableDictionary *param = [@{@"schoolName": school.name} mutableCopy];
    if ([school.sid yx_isValidString]) {
        [param setObject:school.sid forKey:@"schoolid"];
    }
    WEAK_SELF
    [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeSchool param:param completion:^(NSError *error) {
        STRONG_SELF
        [self nyx_enableRightNavigationItem];
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        [self.navigationController popToViewController:self.baseVC animated:YES];
    }];
}

@end

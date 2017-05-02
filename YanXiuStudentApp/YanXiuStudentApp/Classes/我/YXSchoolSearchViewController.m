//
//  YXSchoolSearchViewController.m
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXSchoolSearchViewController.h"
#import "YXSchoolSearchRequest.h"
#import "UIColor+YXColor.h"
#import "YXAreaSeperatorView.h"
#import "YXSchoolSearchCell.h"
#import "YXSchoolSearchHeaderView.h"
#import "YXCommonLabel.h"
#import "YXUpdateUserInfoRequest.h"

@interface YXSchoolSearchViewController ()<UISearchBarDelegate, UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *textFieldClipsView;
@property (nonatomic, strong) UIView *searchResultView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *inputBgView;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIImageView *tipImageView;
@property (nonatomic, strong) UIImageView *searchImageView;
@property (nonatomic, strong) YXAreaSeperatorView *sepView;
@property (nonatomic, strong) YXCommonLabel *tipLabel;
@property (nonatomic, strong) YXSchool *mySelectedSchool;
@property (nonatomic, strong) YXSchoolSearchRequest *request;
@property (nonatomic, strong) YXSchoolSearchItem *item;

@end

@implementation YXSchoolSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学校名称";
    
    [self yx_setupLeftBackBarButtonItem];
    [self setupHeaderView];
    [self setupResultView];
    [self setupConstraints];
    
    [self startSchoolSearch:self.district.name];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupHeaderView {
    UIImage *bgImage = [UIImage imageNamed:@"搜索按钮背景"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    self.bgView = [[UIImageView alloc]initWithImage:bgImage];
    self.bgView.userInteractionEnabled = YES;
    [self.view addSubview:self.bgView];
  
    
    UIImage *inputBgImage = [UIImage imageNamed:@"输入框背景"];
    inputBgImage = [inputBgImage stretchableImageWithLeftCapWidth:inputBgImage.size.width/2 topCapHeight:inputBgImage.size.height/2];
    self.inputBgView = [[UIImageView alloc]initWithImage:inputBgImage];
    self.inputBgView.userInteractionEnabled = YES;
    [self.bgView addSubview:self.inputBgView];

    
    self.addButton = [[UIButton alloc] init];
    [self.addButton setBackgroundImage:[[UIImage imageNamed:@"弹框按钮背景"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateNormal];
    [self.addButton setBackgroundImage:[[UIImage imageNamed:@"弹框按钮背景-按下"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)] forState:UIControlStateHighlighted];
    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor colorWithHexString:@"805500"] forState:UIControlStateNormal];
    self.addButton.titleLabel.font = [UIFont boldSystemFontOfSize:13];
    self.addButton.titleLabel.layer.shadowColor = [UIColor colorWithHexString:@"ffff99"].CGColor;
    self.addButton.titleLabel.layer.shadowOffset = CGSizeMake(0, 1);
    self.addButton.titleLabel.layer.shadowRadius = 0;
    self.addButton.titleLabel.layer.shadowOpacity = 1;
    [self.addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.addButton];
    
    
    self.sepView = [[YXAreaSeperatorView alloc]init];
    self.sepView.layer.shadowColor = [UIColor colorWithHexString:@"ffeb66"].CGColor;
    self.sepView.layer.shadowOffset = CGSizeMake(0, 1);
    self.sepView.layer.shadowRadius = 0;
    self.sepView.layer.shadowOpacity = 1;
    [self.bgView addSubview:self.sepView];
    
    self.tipImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tips-icon-yellow"]];
    [self.bgView addSubview:self.tipImageView];
    self.tipLabel = [[YXCommonLabel alloc] init];
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    self.tipLabel.text = @"没有找到？请输入学校名称添加 ^_^";
    [self.bgView addSubview:self.tipLabel];
    
    self.searchImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"我的学校-放大镜"]];
    [self.inputBgView addSubview:self.searchImageView];

    self.textFieldClipsView = [[UIView alloc] init];
    self.textFieldClipsView.backgroundColor = [UIColor clearColor];
    self.textFieldClipsView.clipsToBounds = YES;
    [self.inputBgView addSubview:self.textFieldClipsView];
    
    self.textField = [[UITextField alloc] init];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.font = [UIFont boldSystemFontOfSize:17];
    self.textField.placeholder = @"请输入学校名称";
    self.textField.tintColor = [UIColor whiteColor];
    self.textField.returnKeyType = UIReturnKeySearch;
    [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.layer.shadowOffset = CGSizeMake(0, 1);
    self.textField.layer.shadowRadius = 0;
    self.textField.layer.shadowOpacity = 1;
    self.textField.layer.shadowColor = [UIColor colorWithHexString:@"bd8e00"].CGColor;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.textFieldClipsView addSubview:self.textField];
}

- (void)setupConstraints {
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(25);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(60);
    }];
        
    [self.inputBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(12);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(36);
    }];
        
    self.addButton.hidden = YES;
    self.sepView.hidden = YES;
    self.tipImageView.hidden = YES;
    self.tipLabel.hidden = YES;
        
    [self.searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    [self.textFieldClipsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.searchImageView.mas_right).mas_offset(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(21);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
}

- (void)setupResultView {
    self.searchResultView = [[UIView alloc]init];
    UIImage *bgImage = [UIImage imageNamed:@"搜索列表背景"];
    bgImage = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2];
    UIImageView *bgView = [[UIImageView alloc]initWithImage:bgImage];
    bgView.userInteractionEnabled = YES;
    [self.searchResultView addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tableView removeFromSuperview];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 45;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(-4, 0, -20, 0);
    [bgView addSubview:self.tableView];
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(12, 6, 12, 6));
    }];
}

- (void)startSchoolSearch:(NSString *)searchText {
    searchText = [searchText yx_stringByTrimmingCharacters];

    if (self.request) {
        [self.request stopRequest];
    }
    
    if (searchText.length == 0) {
        searchText = self.district.name;
    }
    
    self.request = [[YXSchoolSearchRequest alloc] init];
    self.request.school = searchText;
    self.request.regionId = self.district.did;
    
    @weakify(self);
    [self.request startRequestWithRetClass:[YXSchoolSearchItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        self.item = retItem;
        
        if (self.item.data.count == 0) {
            [self.searchResultView removeFromSuperview];
            // 点击搜索后 才有提示框 
            if (!self.textField.isFirstResponder) {
                [self yx_showToast:@"没有搜索到相应的学校"];
            }
        }else{
            [self.view addSubview:self.searchResultView];
            [self relayoutResultView];
            [self.tableView reloadData];
        }
    }];
}

- (void)relayoutResultView {
    CGFloat maxHeight = self.view.frame.size.height-25-96-15;
    CGFloat contentHeight = self.item.data.count*45+35+12+12;
    CGFloat height = MIN(maxHeight, contentHeight);
    [self.searchResultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(25);
        make.top.mas_equalTo(15+96);
        make.right.mas_equalTo(-25);
        make.height.mas_equalTo(height);
    }];
}

- (void)addAction:(id)sender {
    NSString *schoolName = [self.textField.text yx_stringByTrimmingCharacters];
    if ([schoolName yx_isValidString]) {
        NSError *error = nil;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:schoolName forKey:@"name"];
        YXSchool *school = [[YXSchool alloc] initWithDictionary:dict error:&error];
        [self selectedSchool:school];
    }
}

- (void)selectedSchool:(YXSchool *)school {
    if (self.selectedSchoolBlock) {
        self.selectedSchoolBlock(school);
    }
    [self yx_leftBackButtonPressed:nil];
}

- (void)textDidChange:(UITextField *)textField {
    [self startSchoolSearch:textField.text];
}

- (void)saveSelectedSchool {
    if ([[YXUserManager sharedManager] isLogin]) { //已登录，直接请求网络修改地区信息
        if ([self.district.did isEqualToString:[YXUserManager sharedManager].userModel.areaid]
            && [self.district.name isEqualToString:[YXUserManager sharedManager].userModel.areaName]) {
            [self backToViewController:@"YXMyProfileViewController"];
            return;
        }
        
        NSDictionary *param = @{@"provinceid":self.province.pid,
                                @"provinceName":self.province.name,
                                @"cityid":self.city.cid,
                                @"cityName":self.city.name,
                                @"areaid":self.district.did,
                                @"areaName":self.district.name,
                                };
        @weakify(self);
        [self yx_startLoading];
        [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeArea param:param completion:^(NSError *error) {
            @strongify(self);
            [self yx_stopLoading];
            if (!error) {
                [self updateRequestWithSchool:self.mySelectedSchool];
            } else {
                [self yx_showToast:error.localizedDescription];
            }
        }];
    } else {
        NSDictionary *userInfo = @{@"province": self.province,
                                   @"city": self.city,
                                   @"district": self.district,
                                   @"school": self.mySelectedSchool
                                   };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"YXSchoolSelectedNotification"
                                                            object:nil
                                                          userInfo:userInfo];
        [self backToViewController:@"YXEditProfileViewController"];
    }
}

- (void)backToViewController:(NSString *)controllerName {
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(controllerName)]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)updateRequestWithSchool:(YXSchool *)school {
    if (![school.name yx_isValidString]
        || [school.name isEqualToString:[YXUserManager sharedManager].userModel.schoolName]) {
        return;
    }
    
    NSMutableDictionary *param = [@{@"schoolName": school.name} mutableCopy];
    if ([school.sid yx_isValidString]) {
        [param setObject:school.sid forKey:@"schoolid"];
    }
    @weakify(self);
    [self yx_startLoading];
    [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeSchool param:param completion:^(NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        } else {
            [self backToViewController:@"YXMyProfileViewController"];

        }
    }];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self startSchoolSearch:textField.text];
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"kUITableViewCell";
    YXSchoolSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[YXSchoolSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.title = ((YXSchool *)self.item.data[indexPath.row]).name;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.mySelectedSchool = self.item.data[indexPath.row];
    //[self selectedSchool:self.item.data[indexPath.row]];
    [self saveSelectedSchool];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *identifier = @"YXSchoolSearchHeaderView";
    YXSchoolSearchHeaderView *v = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!v) {
        v = [[YXSchoolSearchHeaderView alloc] initWithReuseIdentifier:identifier];
    }
    return v;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.textField resignFirstResponder];
}

@end

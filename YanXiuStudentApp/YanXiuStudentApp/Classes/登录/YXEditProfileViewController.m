//
//  YXEditProfileViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/3.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXEditProfileViewController.h"
#import "YXWordInputView.h"
#import "YXCommonButton.h"
#import "YXMineTableViewCell.h"
#import "YXLoginCell.h"

#import "YXSchoolSearchViewController.h"
#import "YXAreaViewController.h"
#import "YXStageViewController.h"

#import "YXRegisterRequest.h"
#import "YXSchoolSearchRequest.h"
#import "YXProvinceList.h"
#import "YXThirdRegisterRequest.h"
#import "YXSSOAuthDefine.h"
#import "YXRecordManager.h"
#import "RegisterByUserInfoRequest.h"
#import "NameInputView.h"
#import "NameView.h"


static NSString *const kYXLoginEnterCellIdentifier = @"kYXLoginEnterCellIdentifier";
@interface YXEditProfileViewController ()

@property (nonatomic, strong) NameInputView *realNameInput;
@property (nonatomic, strong) YXCommonButton *submitButton;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSString *provinceText;
@property (nonatomic, strong) NSString *schoolText;
@property (nonatomic, strong) NSString *stageText;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *stageId;
@property (nonatomic, strong) YXProvince *province;
@property (nonatomic, strong) YXCity *city;
@property (nonatomic, strong) YXDistrict *district;
@property (nonatomic, strong) YXSchool *selectedSchool;

@end

@implementation YXEditProfileViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"完善资料";
    [self yx_setupLeftBackBarButtonItem];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(schoolSelected:)
                   name:@"YXSchoolSelectedNotification"
                 object:nil];
    [self.tableView registerClass:[YXMineTableViewCell class] forCellReuseIdentifier:kYXLoginEnterCellIdentifier];
    [self.tableView registerClass:[YXLoginCell class] forCellReuseIdentifier:kYXLoginCellIdentifier];
    self.names = @[@"学校", @"学段"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerTextNotifications];
    [self resetButtonEnable];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self removeTextNotifications];
}

- (void)setMobile:(NSString *)mobile password:(NSString *)password
{
    self.mobile = mobile;
    self.password = password;
}

- (void)setThirdLoginParams:(NSDictionary *)params {
    _thirdLoginParams = params;
}

#pragma mark -

- (void)registerTextNotifications
{
    [self removeTextNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //键盘显示通知
    [center addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
    [center addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    //UITextField文本变化通知
    [center addObserver:self
               selector:@selector(textDidChange)
                   name:UITextFieldTextDidChangeNotification
                 object:nil];
}

- (void)removeTextNotifications
{
    [self.realNameInput resignFirstResponder];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self
                      name:UIKeyboardWillShowNotification
                    object:nil];
    [center removeObserver:self
                      name:UIKeyboardWillHideNotification
                    object:nil];
    [center removeObserver:self
                      name:UITextFieldTextDidChangeNotification
                    object:nil];
}

#pragma mark - Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    CGRect keyboardFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    self.tableView.contentSize = CGSizeMake(0, CGRectGetHeight(self.tableView.bounds) + CGRectGetHeight(keyboardFrame));
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.tableView.contentSize = CGSizeMake(0, CGRectGetHeight(self.tableView.bounds));
}

- (void)textDidChange
{
    [self resetButtonEnable];
}

- (void)resetButtonEnable {
    if ([self.realNameInput.text yx_isValidString]
        && [self.selectedSchool.name yx_isValidString]
        && [self.stageText yx_isValidString]) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }
}

- (void)schoolSelected:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo.allKeys.count >= 3) {
        self.province = [userInfo objectForKey:@"province"];
        self.city = [userInfo objectForKey:@"city"];
        self.district = [userInfo objectForKey:@"district"];
        self.selectedSchool = [userInfo objectForKey:@"school"];
        [self.tableView reloadData];
    }
}

- (NSString *)provinceText {
    if (![self.province.name yx_isValidString]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@/%@", self.province.name, self.city.name, self.district.name];;
}

#pragma mark -

- (NameInputView *)realNameInput
{
    if (!_realNameInput) {
        _realNameInput = [[NameInputView alloc] init];
    }
    return _realNameInput;
}

- (YXCommonButton *)submitButton
{
    if (!_submitButton) {
        _submitButton = [[YXCommonButton alloc] init];
        [_submitButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
        [self resetButtonEnable];
    }
    return _submitButton;
}

- (void)submitAction:(id)sender {
    [self.realNameInput resignFirstResponder];
    
    if (self.isThirdLogin) {
        [self startThirdLogin];
    } else {
        [self startRegisterRequest];
    }
}

- (void)startRegisterRequest {
    WEAK_SELF
    [self yx_startLoading];
    
    RegisterModel *model = [[RegisterModel alloc]init];
    model.mobile = self.mobile;
    model.realname = self.realNameInput.text;
    model.provinceid = self.province.pid;
    model.cityid = self.city.cid;
    model.areaid = self.district.did;
    model.stageid = self.stageId;
    model.schoolName = self.selectedSchool.name;
    model.schoolid = self.selectedSchool.sid;
    model.validKey = [[NSString stringWithFormat:@"%@&%@", self.mobile, @"yxylmobile"] md5];
    
    [LoginDataManager registerWithModel:model completeBlock:^(YXRegisterRequestItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
    }];
}

// 第三方登录注册
- (void)startThirdLogin {
    WEAK_SELF;
    [self yx_startLoading];
    
    ThirdRegisterModel *model = [[ThirdRegisterModel alloc]init];
    model.openid = [self.thirdLoginParams objectForKey:YXSSOAuthOpenidKey];
    model.pltform = [self.thirdLoginParams objectForKey:YXSSOAuthPltformKey];
    model.sex = [self.thirdLoginParams objectForKey:YXSSOAuthSexKey];
    model.headimg = [self.thirdLoginParams objectForKey:YXSSOAuthHeadimgKey];
    model.unionId = [self.thirdLoginParams objectForKey:YXSSOAuthUnionKey];
    model.realname = self.realNameInput.text;
    model.provinceid = self.province.pid;
    model.cityid = self.city.cid;
    model.areaid = self.district.did;
    model.stageid = self.stageId;
    model.schoolname = self.selectedSchool.name;
    model.schoolid = self.selectedSchool.sid;
    
    [LoginDataManager thirdRegisterWithModel:model completeBlock:^(YXThirdRegisterRequestItem *item, NSError *error) {
        STRONG_SELF;
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
    }];
}

#pragma mark -
- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    return self.realNameInput;
                default:
                    return nil;
            }
        }
        case 1:
            return self.submitButton;
        default:
            return nil;
    }
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
        {
            YXAreaViewController *vc = [[YXAreaViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case 2:
        {
            YXStageViewController *vc = [[YXStageViewController alloc] init];
            vc.isRegisterAccount = YES;
            @weakify(self);
            vc.selectBlock = ^(NSString *stageId, NSString *stageName) {
                @strongify(self);
                self.stageText = stageName;
                self.stageId = stageId;
                [self.tableView reloadData];
            };
            vc.stageid = self.stageId;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

- (BOOL)showLineAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = [self tableView:self.tableView numberOfRowsInSection:indexPath.section];
    return (indexPath.row < count - 1) && (count > 1);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 25.f;
    }
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat defaultHeight = 60.f;
    if ([self showLineAtIndexPath:indexPath]) {
        defaultHeight += 2.f;
    }
    return defaultHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row >= 1 && indexPath.row <= 2) {
        YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXLoginEnterCellIdentifier];
        cell.showLine = [self showLineAtIndexPath:indexPath];
        [cell setTitle:self.names[indexPath.row - 1] image:nil];
        switch (indexPath.row) {
            case 1:
                [cell updateWithAccessoryText:self.selectedSchool.name];
                break;
            case 2:
                [cell updateWithAccessoryText:self.stageText];
                break;
            default:
                break;
        }
        return cell;
    }
    
    YXLoginCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXLoginCellIdentifier];
    cell.interval = (indexPath.row == 0) ? 2.f:1.5f;
    cell.containerView = [self viewForRowAtIndexPath:indexPath];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    return cell;
}

@end

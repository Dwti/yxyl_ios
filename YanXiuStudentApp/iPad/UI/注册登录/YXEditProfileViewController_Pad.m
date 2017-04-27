//
//  YXEditProfileViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/26.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXEditProfileViewController_Pad.h"
#import "YXWordInputView.h"
#import "YXCommonButton.h"
#import "YXMineTableViewCell.h"
#import "YXLoginCell.h"

#import "YXRegisterRequest.h"
#import "YXSchoolSearchRequest.h"
#import "YXProvinceList.h"
#import "YXThirdRegisterRequest.h"
#import "YXSSOAuthDefine.h"

#import "YXSchoolSearchViewController_Pad.h"
#import "YXAreaSelectViewController_Pad.h"
#import "YXStageChooseViewController_Pad.h"
#import "YXRecordManager.h"

static NSString *const kYXLoginEnterCellIdentifier = @"kYXLoginEnterCellIdentifier";

@interface YXEditProfileViewController_Pad ()

@property (nonatomic, strong) YXWordInputView *realNameInput;
@property (nonatomic, strong) YXWordInputView *nickNameInput;
@property (nonatomic, strong) YXCommonButton *submitButton;
@property (nonatomic, strong) NSArray *names;
@property (nonatomic, strong) NSString *provinceText;
@property (nonatomic, strong) NSString *schoolText;
@property (nonatomic, strong) NSString *stageText;

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) YXProvince *province;
@property (nonatomic, strong) YXCity *city;
@property (nonatomic, strong) YXDistrict *district;

@property (nonatomic, strong) YXSchool *selectedSchool;

@property (nonatomic, strong) NSString *stageId;

@property (nonatomic, strong) YXRegisterRequest *request;
@property (nonatomic, strong) YXThirdRegisterRequest *thirdRegisterRequest;
@property (nonatomic, assign) BOOL isThirdLogin;

@end

@implementation YXEditProfileViewController_Pad

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    [self yx_setupLeftBackBarButtonItem];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(provinceSelected:)
                   name:@"YXProvinceSelectedNotification"
                 object:nil];
    [self.tableView registerClass:[YXMineTableViewCell class] forCellReuseIdentifier:kYXLoginEnterCellIdentifier];
    self.names = @[@"地区", @"学校", @"学段"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.request stopRequest];
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

- (void)setThirdLoginParams:(NSDictionary *)params
{
    self.isThirdLogin = YES;
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
    [self.nickNameInput resignFirstResponder];
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

- (void)resetButtonEnable
{
    if ([self.realNameInput.text yx_isValidString]
        && [self.nickNameInput.text yx_isValidString]
        && [self.provinceText yx_isValidString]
        && [self.schoolText yx_isValidString]
        && [self.stageText yx_isValidString]) {
        self.submitButton.enabled = YES;
    } else {
        self.submitButton.enabled = NO;
    }
}

- (void)provinceSelected:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo.allKeys.count >= 3) {
        self.province = [userInfo objectForKey:@"province"];
        self.city = [userInfo objectForKey:@"city"];
        self.district = [userInfo objectForKey:@"district"];
        self.schoolText = [userInfo objectForKey:@"school"];
        [self.tableView reloadData];
    }
}

- (NSString *)provinceText
{
    if (![self.province.name yx_isValidString]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@/%@/%@", self.province.name, self.city.name, self.district.name];;
}

#pragma mark -

- (YXWordInputView *)realNameInput
{
    if (!_realNameInput) {
        _realNameInput = [[YXWordInputView alloc] init];
        _realNameInput.placeholder = @"姓名";
    }
    return _realNameInput;
}

- (YXWordInputView *)nickNameInput
{
    if (!_nickNameInput) {
        _nickNameInput = [[YXWordInputView alloc] init];
        _nickNameInput.placeholder = @"昵称";
        if (self.isThirdLogin) {
            _nickNameInput.text = [self.thirdLoginParams objectForKey:YXSSOAuthNicknameKey];
        }
    }
    return _nickNameInput;
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

- (void)submitAction:(id)sender
{
    if (self.isThirdLogin) {
        [self startThirdLogin];
    } else {
        [self startRegisterRequest];
    }
}

- (void)startRegisterRequest
{
    if (self.request) {
        [self.request stopRequest];
    }
    self.request = [[YXRegisterRequest alloc] init];
    self.request.mobile = self.mobile;
    self.request.password = self.password;
    self.request.realname = [self.realNameInput.text yx_stringByTrimmingCharacters];
    self.request.nickname = [self.nickNameInput.text yx_stringByTrimmingCharacters];
    self.request.provinceid = self.province.pid;
    self.request.cityid = self.city.cid;
    self.request.areaid = self.district.did;
    self.request.stageid = self.stageId;
    self.request.schoolName = self.selectedSchool.name;
    NSString *sid = self.selectedSchool.sid;
    if ([sid yx_isValidString]) {
        self.request.schoolid = sid;
    }
    
    @weakify(self);
    [self yx_startLoading];
    [self.request startRequestWithRetClass:[YXRegisterRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXRegisterRequestItem *item = retItem;
        if (item.data.count > 0 && !error) {
            [self saveUserDataWithUserModel:item.data[0] isThirdLogin:NO];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
        [YXRecordManager addRecordWithType:YXRecordResigerType];
    }];
}

// 第三方登录注册
- (void)startThirdLogin
{
    if (self.thirdRegisterRequest) {
        [self.thirdRegisterRequest stopRequest];
    }
    self.thirdRegisterRequest = [[YXThirdRegisterRequest alloc] init];
    self.thirdRegisterRequest.openid = [self.thirdLoginParams objectForKey:YXSSOAuthOpenidKey];
    self.thirdRegisterRequest.unionId = [self.thirdLoginParams objectForKey:YXSSOAuthUnionKey];
    self.thirdRegisterRequest.pltform = [self.thirdLoginParams objectForKey:YXSSOAuthPltformKey];
    self.thirdRegisterRequest.sex = [self.thirdLoginParams objectForKey:YXSSOAuthSexKey];
    self.thirdRegisterRequest.headimg = [self.thirdLoginParams objectForKey:YXSSOAuthHeadimgKey];
    self.thirdRegisterRequest.realname = [self.realNameInput.text yx_stringByTrimmingCharacters];
    self.thirdRegisterRequest.nickName = [self.nickNameInput.text yx_stringByTrimmingCharacters];
    self.thirdRegisterRequest.provinceid = self.province.pid;
    self.thirdRegisterRequest.cityid = self.city.cid;
    self.thirdRegisterRequest.areaid = self.district.did;
    self.thirdRegisterRequest.stageid = self.stageId;
    self.thirdRegisterRequest.schoolname = self.selectedSchool.name;
    NSString *sid = self.selectedSchool.sid;
    if ([sid yx_isValidString]) {
        self.thirdRegisterRequest.schoolid = sid;
    }
    
    @weakify(self);
    [self yx_startLoading];
    [self.thirdRegisterRequest startRequestWithRetClass:[YXThirdRegisterRequestItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXThirdRegisterRequestItem *item = retItem;
        if (item.data.count > 0 && !error) {
            [self saveUserDataWithUserModel:item.data[0] isThirdLogin:YES];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

// 保存用户信息并发送登录成功通知
- (void)saveUserDataWithUserModel:(YXUserModel *)model
                     isThirdLogin:(BOOL)isThirdLogin
{
    [YXUserManager sharedManager].userModel = model;
    [[YXUserManager sharedManager] setIsThirdLogin:isThirdLogin];
    [[YXUserManager sharedManager] login];
}

#pragma mark -

- (UIView *)viewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                    return self.realNameInput;
                case 1:
                    return self.nickNameInput;
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

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 2:
        {
            YXAreaSelectViewController_Pad *vc = [[YXAreaSelectViewController_Pad alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            YXSchoolSearchViewController_Pad *vc = [[YXSchoolSearchViewController_Pad alloc] init];
            vc.isRegisteringAccount = YES;
            if (self.district) {
                vc.areaId = self.district.did;
            }
            @weakify(self);
            vc.selectedSchoolBlock = ^(YXSchool *school) {
                @strongify(self);
                self.schoolText = school.name;
                self.selectedSchool = school;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            YXStageChooseViewController_Pad *vc = [[YXStageChooseViewController_Pad alloc] init];
            @weakify(self);
            vc.selectBlock = ^(NSString *stageId, NSString *stageName) {
                @strongify(self);
                self.stageText = stageName;
                self.stageId = stageId;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self didSelectRowAtIndexPath:indexPath];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
        case 1:
            return 1;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row >= 2 && indexPath.row <= 4) {
        YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXLoginEnterCellIdentifier];
        cell.showLine = [self showLineAtIndexPath:indexPath];
        [cell setTitle:self.names[indexPath.row - 2] image:nil];
        switch (indexPath.row) {
            case 2:
                [cell updateWithAccessoryText:self.provinceText];
                break;
            case 3:
                [cell updateWithAccessoryText:self.schoolText];
                break;
            case 4:
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

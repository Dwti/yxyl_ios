//
//  YXMyProfileViewController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMyProfileViewController.h"
#import "YXMineTableViewCell.h"
#import "YXImagePickerController.h"
#import "YXMineManager.h"
#import "YXProvinceList.h"
#import "YXUpdateUserInfoRequest.h"
#import "YXSchoolSearchRequest.h"

#import "YXModifyNameViewController.h"
#import "YXModifyNickNameViewController.h"
#import "YXSexViewController.h"
#import "YXAreaViewController.h"
#import "YXSchoolSearchViewController.h"
#import "ChangeView.h"

@interface YXMyProfileViewController ()

@property (nonatomic, strong) YXImagePickerController *imagePickerController;
@property (nonatomic, strong) EEAlertView *alertView;
@property (nonatomic, strong) YXUploadHeadImgRequest *uploadHeadImgRequest;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *selectedItems;
@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) YXUserModel *userModel;

@end

@implementation YXMyProfileViewController

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    [self yx_setupLeftBackBarButtonItem];
    
    self.items = @[@[@"头像", @"姓名", @"昵称"],
                   @[@"性别", @"学校"]];
    self.controllers = @[@[@"", @"YXModifyNameViewController", @"YXModifyNickNameViewController"],
                         @[@"YXSexViewController", @"YXAreaViewController"]];
    self.headerImage = [UIImage imageNamed:@"默认头像"];
    
    [self loadUserModel];
    [self registerNotifications];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTableViewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)registerNotifications
{
    [self removeNotifications];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(updateUserInfoSuccess:)
                   name:YXUpdateUserInfoSuccessNotification
                 object:nil];
}

- (void)removeNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateUserInfoSuccess:(NSNotification *)notification
{
    [self reloadTableViewData];
}

#pragma mark -

- (void)loadUserModel
{
    self.userModel = [YXUserManager sharedManager].userModel;
    if (self.userModel) {
        NSUInteger index = [YXMineManager indexWithSexId:self.userModel.sex];
        NSString *sex = @"未知";
        if (index != NSNotFound) {
            sex = [YXMineManager sexNames][index];
        }
        
        self.selectedItems = @[@[@"",
                                 self.userModel.realname ?:@"",
                                 self.userModel.nickname ?:@""],
                               @[sex,
                                 self.userModel.schoolName ?:@""]];
    }
}

- (void)reloadTableViewData
{
    [self loadUserModel];
    [self.tableView reloadData];
}

- (YXImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[YXImagePickerController alloc] init];
    }
    return _imagePickerController;
}

- (void)changeAvatar
{

    self.alertView = [[EEAlertView alloc] init];
    
    ChangeView *containerView = [[ChangeView alloc] init];
    self.alertView.contentView = containerView;
    
    WEAK_SELF
    [[containerView.cameraButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        WEAK_SELF
        [self.alertView hide];
        [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage *selectedImage) {
            STRONG_SELF
            [self updateWithHeaderImage:selectedImage];
        }];
        
    }];

    [[containerView.albumButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        STRONG_SELF
        WEAK_SELF
        [self.alertView hide];
        [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
            STRONG_SELF
            [self updateWithHeaderImage:selectedImage];
        }];
    }];
    
    [containerView.cancelButton addTarget:self.alertView action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    
    [self.alertView showWithLayout:^(AlertView *view) {
        [view.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(306);
            make.centerX.mas_equalTo(0);
            make.top.equalTo(view.mas_bottom).offset(0);
        }];
        [view layoutIfNeeded];
        
        [UIView animateWithDuration:0.3f animations:^{
            [view.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(306);
                make.centerX.mas_equalTo(0);
                make.bottom.mas_equalTo(-30);
            }];
            [view layoutIfNeeded];
        }];
        
    }];
}

- (void)updateWithHeaderImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    WEAK_SELF
    [self yx_startLoading];
    [[YXUpdateUserInfoHelper instance]updateHeadImageWithImage:image completeBlock:^(YXUploadHeadImgItem *item, NSError *error) {
        STRONG_SELF
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
            return;
        }
        self.headerImage = image;
        [self reloadTableViewData];
    }];
}

- (void)updateRequestWithSchool:(YXSchool *)school
{
    if (![school.name yx_isValidString]
        || [school.name isEqualToString:self.userModel.schoolName]) {
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
        }
    }];
}

- (void)updateRequestWithSexId:(NSString *)sexId
{
    if ([sexId isEqualToString:self.userModel.sex]) {
        return;
    }
    @weakify(self);
    [self yx_startLoading];
    [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeSex param:@{@"sex":sexId} completion:^(NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        if (error) {
            [self yx_showToast:error.localizedDescription];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)self.items[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YXMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kYXMineCellIdentifier];
    [cell setTitle:self.items[indexPath.section][indexPath.row] image:nil];
    cell.showLine = [self showLineAtIndexPath:indexPath];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [cell updateWithImageUrl:self.userModel.head defaultImage:self.headerImage];
        [cell updateWithAccessoryText:nil];
    } else {
        [cell updateWithImageUrl:nil defaultImage:nil];
        [cell updateWithAccessoryText:self.selectedItems[indexPath.section][indexPath.row]];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 88.f;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self changeAvatar];
        return;
    }
    
    NSString *vcString = self.controllers[indexPath.section][indexPath.row];
    YXMineBaseViewController *vc = [[NSClassFromString(vcString) alloc] init];
//    if ([vc isKindOfClass:[YXSchoolSearchViewController class]]) {
//        ((YXSchoolSearchViewController *)vc).areaId = [YXUserManager sharedManager].userModel.areaid;
//        ((YXSchoolSearchViewController *)vc).selectedSchoolBlock = ^(YXSchool *school) {
//            [self updateRequestWithSchool:school];
//        };
//    }
    if ([vc isKindOfClass:[YXSexViewController class]]) {
        ((YXSexViewController *)vc).selectBlock = ^(NSString *sexId) {
            [self updateRequestWithSexId:sexId];
        };
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

@end

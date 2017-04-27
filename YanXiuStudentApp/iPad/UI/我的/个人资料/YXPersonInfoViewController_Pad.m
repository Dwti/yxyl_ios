//
//  YXPersonInfoViewController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXPersonInfoViewController_Pad.h"
#import "YXImagePickerController_Pad.h"
#import "YXAlertView.h"
#import "YXMineManager.h"
#import "YXProvinceList.h"
#import "YXUpdateUserInfoRequest.h"
#import "YXSchoolSearchRequest.h"
#import "YXUploadHeadImgRequest.h"
#import "UIImage+YXImage.h"

#import "YXModifyNameViewController_Pad.h"
#import "YXModifyNicknameViewController_Pad.h"
#import "YXSexViewController_Pad.h"
#import "YXAreaSelectViewController_Pad.h"
#import "YXSchoolSearchViewController_Pad.h"

@interface YXPersonInfoViewController_Pad ()

@property (nonatomic, strong) YXImagePickerController_Pad *imagePickerController;
@property (nonatomic, strong) YXAlertView *actionSheet;
@property (nonatomic, strong) YXUploadHeadImgRequest *uploadHeadImgRequest;

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSArray *selectedItems;
@property (nonatomic, strong) NSArray *controllers;
@property (nonatomic, strong) UIImage *headerImage;
@property (nonatomic, strong) YXUserModel *userModel;

@end

@implementation YXPersonInfoViewController_Pad

- (void)dealloc
{
    [self removeNotifications];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    
    self.items = @[@[@"头像", @"姓名", @"昵称"],
                   @[@"性别", @"地区", @"学校"]];
    self.controllers = @[@[@"", @"YXModifyNameViewController_Pad", @"YXModifyNicknameViewController_Pad"],
                         @[@"YXSexViewController_Pad", @"YXAreaSelectViewController_Pad", @"YXSchoolSearchViewController_Pad"]];
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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[YXUpdateUserInfoHelper instance] stopRequest];
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
        NSString *area = [NSString stringWithFormat:@"%@/%@/%@", self.userModel.provinceName, self.userModel.cityName, self.userModel.areaName];
        NSUInteger index = [YXMineManager indexWithSexId:self.userModel.sex];
        NSString *sex = @"未知";
        if (index != NSNotFound) {
            sex = [YXMineManager sexNames][index];
        }
        self.selectedItems = @[@[@"",
                                 self.userModel.realname ?:@"",
                                 self.userModel.nickname ?:@""],
                               @[sex,
                                 area,
                                 self.userModel.schoolName ?:@""]];
    }
}

- (void)reloadTableViewData
{
    [self loadUserModel];
    [self.tableView reloadData];
}

- (YXImagePickerController_Pad *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [YXImagePickerController_Pad instance];
    }
    return _imagePickerController;
}

- (void)changeAvatar
{
    [self.actionSheet showInView:self.view];
}

- (YXAlertView *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [YXAlertView alertWithMessage:@"请拍照，或选择相册中的图片" style:YXAlertStyleAlert contentSize:CGSizeMake(306, 181)];
        @weakify(self);
        [_actionSheet addButtonWithTitle:@"拍照" image:[UIImage imageNamed:@"相机"] highlightedImage:[UIImage imageNamed:@"相机"] action:^{
            @strongify(self);
            @weakify(self);
            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypeCamera completion:^(UIImage *selectedImage) {
                @strongify(self);
                [self updateWithHeaderImage:selectedImage];
            }];
        }];
        
        [_actionSheet addButtonWithTitle:@"相册" image:[UIImage imageNamed:@"相册"] highlightedImage:[UIImage imageNamed:@"相册"] action:^{
            @strongify(self);
            @weakify(self);
            [self.imagePickerController pickImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary completion:^(UIImage *selectedImage) {
                @strongify(self);
                [self updateWithHeaderImage:selectedImage];
            }];
        }];
        [_actionSheet addCancelButton];
    }
    return _actionSheet;
}

- (void)updateWithHeaderImage:(UIImage *)image
{
    if (!image) {
        return;
    }
    NSData *data = [UIImage compressionImage:image limitSize:2*1024*1024];
    [self.uploadHeadImgRequest stopRequest];
    self.uploadHeadImgRequest = [[YXUploadHeadImgRequest alloc] init];
    [self.uploadHeadImgRequest.request setData:data
                                  withFileName:@"head.jpg"
                                andContentType:nil
                                        forKey:@"file"];
    @weakify(self);
    [self yx_startLoading];
    [self.uploadHeadImgRequest startRequestWithRetClass:[YXUploadHeadImgItem class] andCompleteBlock:^(id retItem, NSError *error) {
        @strongify(self);
        [self yx_stopLoading];
        YXUploadHeadImgItem *item = retItem;
        if (item.data.count > 0 && !error) {
            YXUploadHeadImgItem_Data *data = item.data[0];
            self.userModel.head = data.head;
            [[YXUserManager sharedManager] saveUserData];
            self.headerImage = image;
            [self reloadTableViewData];
            [[NSNotificationCenter defaultCenter] postNotificationName:YXUpdateHeadImgSuccessNotification object:nil];
        } else {
            [self yx_showToast:error.localizedDescription];
        }
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
        [cell updateWithAccessoryText:self.selectedItems[indexPath.section][indexPath.row] isBoldFont:YES];
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
    YXMineBaseViewController_Pad *vc = [[NSClassFromString(vcString) alloc] init];
    if ([vc isKindOfClass:[YXSchoolSearchViewController_Pad class]]) {
        ((YXSchoolSearchViewController_Pad *)vc).areaId = [YXUserManager sharedManager].userModel.areaid;
        ((YXSchoolSearchViewController_Pad *)vc).selectedSchoolBlock = ^(YXSchool *school) {
            [self updateRequestWithSchool:school];
        };
    }
    if ([vc isKindOfClass:[YXSexViewController_Pad class]]) {
        ((YXSexViewController_Pad *)vc).selectBlock = ^(NSString *sexId) {
            [self updateRequestWithSexId:sexId];
        };
    }
    [self.navigationController pushViewController:vc animated:YES];
}

@end

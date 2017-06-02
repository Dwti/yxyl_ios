//
//  CompletePersonalInfoViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "CompletePersonalInfoViewController.h"
#import "PersonalInfoSelectionItemView.h"
#import "ClassInfoItemView.h"
#import "LoginActionView.h"
#import "AreaSelectionViewController.h"
#import "StageSelectionViewController.h"
#import "YXSSOAuthDefine.h"

@interface CompletePersonalInfoViewController ()
@property (nonatomic, strong) ClassInfoItemView *nameView;
@property (nonatomic, strong) PersonalInfoSelectionItemView *schoolView;
@property (nonatomic, strong) PersonalInfoSelectionItemView *stageView;
@property (nonatomic, strong) LoginActionView *submitButton;

@property (nonatomic, strong) YXSchool *school;
@property (nonatomic, strong) YXProvince *province;
@property (nonatomic, strong) YXCity *city;
@property (nonatomic, strong) YXDistrict *district;
@property (nonatomic, strong) NSString *stageID;
@end

@implementation CompletePersonalInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"完善资料";
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    UIImageView *topImageView = [[UIImageView alloc]init];
    topImageView.backgroundColor = [UIColor redColor];
    topImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(200*kPhoneWidthRatio);
    }];
    UIView *containerView = [[UIView alloc]init];
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(35*kPhoneWidthRatio);
        make.right.mas_equalTo(-35*kPhoneWidthRatio);
    }];
    
    self.nameView = [[ClassInfoItemView alloc]init];
    self.nameView.name = @"姓名";
    self.nameView.canEdit = YES;
    self.nameView.inputView.placeHolder = @"请输入真实姓名";
    WEAK_SELF
    [self.nameView setTextChangeBlock:^{
        STRONG_SELF
        NSString *text = self.nameView.text;
        if (text.length>16) {
            self.nameView.inputView.textField.text = [text substringToIndex:16];
        }
        [self refreshSubmitButton];
    }];
    [containerView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    
    self.schoolView = [[PersonalInfoSelectionItemView alloc]init];
    self.schoolView.name = @"学校";
    [self.schoolView setActionBlock:^{
        STRONG_SELF
        [self gotoSchoolSelection];
    }];
    [containerView addSubview:self.schoolView];
    [self.schoolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    
    self.stageView = [[PersonalInfoSelectionItemView alloc]init];
    self.stageView.name = @"学段";
    [self.stageView setActionBlock:^{
        STRONG_SELF
        [self gotoStageSelection];
    }];
    [containerView addSubview:self.stageView];
    [self.stageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.schoolView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    self.submitButton = [[LoginActionView alloc]init];
    self.submitButton.title = @"提 交";
    [self.submitButton setActionBlock:^{
        STRONG_SELF
        [self gotoSubmit];
    }];
    [self.contentView addSubview:self.submitButton];
    [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshSubmitButton];
}

- (void)refreshSubmitButton {
    self.submitButton.isActive = !isEmpty(self.nameView.text)&&!isEmpty(self.stageView.text)&&!isEmpty(self.schoolView.text);
}

- (void)gotoStageSelection {
    StageSelectionViewController *vc = [[StageSelectionViewController alloc]init];
    WEAK_SELF
    [vc setCompleteBlock:^(NSString *stageName,NSString *stageID){
        STRONG_SELF
        self.stageView.text = stageName;
        self.stageID = stageID;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoSchoolSelection {
    AreaSelectionViewController *vc = [[AreaSelectionViewController alloc]init];
    vc.baseVC = self;
    WEAK_SELF
    [vc setSchoolSearchBlock:^(YXSchool *school){
        STRONG_SELF
        self.school = school;
        self.schoolView.text = school.name;
    }];
    [vc setAreaSelectionBlock:^(YXProvince *province,YXCity *city,YXDistrict *district){
        STRONG_SELF
        self.province = province;
        self.city = city;
        self.district = district;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)gotoSubmit {
    if (self.isThirdLogin) {
        [self startThirdRequest];
    } else {
        [self startNormalRequest];
    }
}

- (void)startNormalRequest {
    WEAK_SELF
    [self.view nyx_startLoading];
    
    RegisterModel *model = [[RegisterModel alloc]init];
    model.mobile = self.phoneNum;
    model.realname = self.nameView.text;
    model.provinceid = self.province.pid;
    model.cityid = self.city.cid;
    model.areaid = self.district.did;
    model.stageid = self.stageID;
    model.schoolName = self.school.name;
    model.schoolid = self.school.sid;
    model.validKey = [[NSString stringWithFormat:@"%@&%@", self.phoneNum, @"yxylmobile"] md5];
    
    [LoginDataManager registerWithModel:model completeBlock:^(YXRegisterRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
    }];
}

- (void)startThirdRequest {
    WEAK_SELF;
    [self.view nyx_startLoading];
    
    ThirdRegisterModel *model = [[ThirdRegisterModel alloc]init];
    model.openid = [self.thirdLoginParams objectForKey:YXSSOAuthOpenidKey];
    model.pltform = [self.thirdLoginParams objectForKey:YXSSOAuthPltformKey];
    model.sex = [self.thirdLoginParams objectForKey:YXSSOAuthSexKey];
    model.headimg = [self.thirdLoginParams objectForKey:YXSSOAuthHeadimgKey];
    model.unionId = [self.thirdLoginParams objectForKey:YXSSOAuthUnionKey];
    model.realname = self.nameView.text;
    model.provinceid = self.province.pid;
    model.cityid = self.city.cid;
    model.areaid = self.district.did;
    model.stageid = self.stageID;
    model.schoolname = self.school.name;
    model.schoolid = self.school.sid;
    
    [LoginDataManager thirdRegisterWithModel:model completeBlock:^(YXThirdRegisterRequestItem *item, NSError *error) {
        STRONG_SELF;
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
    }];
}

@end

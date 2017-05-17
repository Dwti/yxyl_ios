//
//  ClassInfoViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ClassInfoViewController.h"
#import "ClassInfoItemView.h"
#import "LoginActionView.h"
#import "YXSSOAuthDefine.h"

@interface ClassInfoViewController ()
@property (nonatomic, strong) ClassInfoItemView *nameView;
@property (nonatomic, strong) LoginActionView *addClassButton;
@end

@implementation ClassInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([YXUserManager sharedManager].isLogin) {
        self.navigationItem.title = @"加入班级";
    }else {
        self.navigationItem.title = @"提交姓名";
    }
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
        make.height.mas_equalTo(120*kPhoneWidthRatio);
    }];
    UIView *containerView = [[UIView alloc]init];
    containerView.layer.cornerRadius = 5;
    containerView.clipsToBounds = YES;
    [self.contentView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topImageView.mas_bottom).mas_offset(57);
        make.left.mas_equalTo(35*kPhoneWidthRatio);
        make.right.mas_equalTo(-35*kPhoneWidthRatio);
    }];
    UILabel *classNameLabel = [[UILabel alloc]init];
    classNameLabel.text = self.rawData.name;
    classNameLabel.font = [UIFont boldSystemFontOfSize:19];
    classNameLabel.textColor = [UIColor whiteColor];
    classNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:classNameLabel];
    [classNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(containerView.mas_top).mas_offset(-22);
        make.centerX.mas_equalTo(self.contentView).mas_offset(6);
    }];
    UIView *dotView = [[UIView alloc]init];
    dotView.backgroundColor = [UIColor whiteColor];
    dotView.layer.cornerRadius = 2.5;
    dotView.clipsToBounds = YES;
    [self.contentView addSubview:dotView];
    [dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(classNameLabel.mas_centerY);
        make.right.mas_equalTo(classNameLabel.mas_left).mas_offset(-8);
        make.size.mas_equalTo(CGSizeMake(5, 5));
    }];
    
    ClassInfoItemView *classCodeView = [[ClassInfoItemView alloc]init];
    classCodeView.name = @"班级号码";
    classCodeView.inputView.textField.text = self.rawData.gid;
    classCodeView.userInteractionEnabled = NO;
    [containerView addSubview:classCodeView];
    [classCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *teacherNameView = [[ClassInfoItemView alloc]init];
    teacherNameView.name = @"老师姓名";
    teacherNameView.inputView.textField.text = self.rawData.authorname;
    teacherNameView.userInteractionEnabled = NO;
    [containerView addSubview:teacherNameView];
    [teacherNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(classCodeView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *classMemberView = [[ClassInfoItemView alloc]init];
    classMemberView.name = @"班级成员";
    classMemberView.inputView.textField.text = [NSString stringWithFormat:@"%@人",self.rawData.stdnum];
    classMemberView.userInteractionEnabled = NO;
    [containerView addSubview:classMemberView];
    [classMemberView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(teacherNameView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
    }];
    ClassInfoItemView *schoolNameView = [[ClassInfoItemView alloc]init];
    schoolNameView.name = @"学校名称";
    schoolNameView.inputView.textField.text = self.rawData.schoolname;
    schoolNameView.userInteractionEnabled = NO;
    [containerView addSubview:schoolNameView];
    [schoolNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(classMemberView.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(0);
    }];
    
    self.nameView = [[ClassInfoItemView alloc]init];
    self.nameView.name = @"你的姓名";
    self.nameView.canEdit = YES;
    self.nameView.inputView.placeHolder = @"请输入你的真实姓名";
    self.nameView.layer.cornerRadius = 5;
    self.nameView.clipsToBounds = YES;
    WEAK_SELF
    [self.nameView setTextChangeBlock:^{
        STRONG_SELF
        NSString *text = self.nameView.text;
        if (text.length>16) {
            self.nameView.inputView.textField.text = [text substringToIndex:16];
        }
        [self refreshAddClassButton];
    }];
    [self.contentView addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.top.mas_equalTo(containerView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
    }];
    
    self.addClassButton = [[LoginActionView alloc]init];
    self.addClassButton.title = @"加入班级";
    [self.addClassButton setActionBlock:^{
        STRONG_SELF
        [self gotoJoinClass];
    }];
    [self.contentView addSubview:self.addClassButton];
    [self.addClassButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameView.mas_left);
        make.right.mas_equalTo(self.nameView.mas_right);
        make.top.mas_equalTo(self.nameView.mas_bottom).mas_offset(15);
        make.height.mas_equalTo(50);
        make.bottom.mas_equalTo(-40);
    }];
    
    [self refreshAddClassButton];
}

- (void)refreshAddClassButton {
    self.addClassButton.isActive = !isEmpty(self.nameView.text);
}

- (void)gotoJoinClass {
    if ([self.rawData memberIsFull]) {
        [self.view nyx_showToast:@"班级已满，不能申请"];
        return;
    }
    
    if ([YXUserManager sharedManager].isLogin) {
        [self joinClass];
    }else {
        if (self.isThirdLogin) {
            [self startThirdJoin];
        } else {
            [self startNormalJoin];
        }
    }
}

- (void)startNormalJoin {
    RegisterByJoinClassModel *model = [[RegisterByJoinClassModel alloc]init];
    model.mobile = self.rawData.mobile;
    model.realname = self.nameView.text;
    model.provinceid = self.rawData.provinceid;
    model.cityid = self.rawData.cityid;
    model.areaid = self.rawData.areaid;
    model.stageid = self.rawData.stageid;
    model.schoolName = self.rawData.schoolname;
    model.schoolid = self.rawData.schoolid;
    model.classId = self.rawData.gid;
    model.validKey = [[NSString stringWithFormat:@"%@&%@", self.rawData.mobile, @"yxylmobile"] md5];
    
    WEAK_SELF
    [self.view nyx_startLoading];
    [LoginDataManager registerByJoinClassWithModel:model completeBlock:^(RegisterRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
    }];
}

- (void)startThirdJoin {
    ThirdRegisterByJoinClassModel *model = [[ThirdRegisterByJoinClassModel alloc]init];
    model.openid = [self.thirdLoginParams objectForKey:YXSSOAuthOpenidKey];
    model.pltform = [self.thirdLoginParams objectForKey:YXSSOAuthPltformKey];
    model.sex = [self.thirdLoginParams objectForKey:YXSSOAuthSexKey];
    model.headimg = [self.thirdLoginParams objectForKey:YXSSOAuthHeadimgKey];
    model.realname = self.nameView.text;
    model.provinceid = self.rawData.provinceid;
    model.cityid = self.rawData.cityid;
    model.areaid = self.rawData.areaid;
    model.stageid = self.rawData.stageid;
    model.schoolname = self.rawData.schoolname;
    model.schoolid = self.rawData.schoolid;
    model.classId = self.rawData.gid;
    
    WEAK_SELF
    [self.view nyx_startLoading];
    [LoginDataManager thirdRegisterByJoinClassWithModel:model completeBlock:^(ThirdRegisterRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
    }];
}

- (void)joinClass {
    [self.view nyx_startLoading];
    WEAK_SELF
    [ClassHomeworkDataManager joinClassWithClassID:self.rawData.gid verifyStatus:self.rawData.status verifyMessage:self.nameView.text completeBlock:^(HttpBaseRequestItem *item, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        if ([self.rawData needToVerify]) {
            [self.view.window nyx_showToast:@"提交成功，等待老师审核"];
        }else{
            [self.view.window nyx_showToast:@"加入成功"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end

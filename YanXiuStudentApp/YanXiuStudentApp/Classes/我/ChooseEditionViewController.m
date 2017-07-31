//
//  ChooseEditionViewController.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "ChooseEditionViewController.h"
#import "QAReportNavView.h"
#import "LoginActionView.h"
#import "ChooseEditionTopView.h"
#import "YXCommonErrorView.h"
#import "YXExerciseEmptyView.h"

static const CGFloat kNavViewHeight = 55.0f;
static const CGFloat kPickerViewHeight = 250.0f;
static const CGFloat kPickerViewWidth = 250.0f;
static const CGFloat kPickerViewRowHeight = 50.0f;

@interface ChooseEditionViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) YXExerciseEmptyView *emptyView;
@property (nonatomic, strong) YXCommonErrorView *errorView;
@property (nonatomic, strong) QAReportNavView *navView;
@property (nonatomic, strong) ChooseEditionTopView *topView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) LoginActionView *confirmView;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) GetEditionRequestItem *item;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) ChooseEditionSuccessBlock successBlock;

@end

@implementation ChooseEditionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"请选择教材版本";
    
    self.emptyView = [[YXExerciseEmptyView alloc] init];
    
    self.errorView = [[YXCommonErrorView alloc] init];
    WEAK_SELF
    [self.errorView setRetryBlock:^{
        STRONG_SELF
        [self requestEditionsWithSubject:self.subject];
    }];
    [self requestEditionsWithSubject:self.subject];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)requestEditionsWithSubject:(GetSubjectRequestItem_subject *)subject {
    WEAK_SELF
    [self.view nyx_startLoading];
    [[ExerciseSubjectManager sharedInstance]requestEditionsWithSubjectID:subject.subjectID completeBlock:^(GetEditionRequestItem *retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (retItem && retItem.editions.count == 0) {
            self.navigationController.navigationBarHidden = NO;
            if (retItem.status.desc) {
                [self.emptyView setEmptyText:retItem.status.desc];
            }
            [self.view addSubview:self.emptyView];
            [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        if (error) {
            self.navigationController.navigationBarHidden = NO;
            [self.view addSubview:self.errorView];
            [self.errorView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
            return;
        }
        self.navigationController.navigationBarHidden = YES;
        [self.emptyView removeFromSuperview];
        [self.errorView removeFromSuperview];
        self.item = retItem;
        [self setupUI];
        [self reloadSelectedEdition];
    }];
    
}

- (void)setupUI{
    self.topView = [[ChooseEditionTopView alloc]init];
    self.topView.subject = self.subject;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(35.f);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(280.f * kPhoneWidthRatio, 280.f * kPhoneWidthRatio));
    }];
    
    self.navView = [[QAReportNavView alloc]init];
    self.navView.title = @"请选择教材版本";
    WEAK_SELF
    [self.navView setBackActionBlock:^{
        STRONG_SELF
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kNavViewHeight);
    }];
    
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(kPickerViewWidth * kPhoneWidthRatio);
        make.height.mas_equalTo(kPickerViewHeight * kPhoneWidthRatio);
    }];
    
    UIView *rectView = [[UIView alloc]init];
    rectView.layer.cornerRadius = 6.f;
    rectView.layer.borderColor = [UIColor whiteColor].CGColor;
    rectView.layer.borderWidth = 2.f;
    rectView.clipsToBounds = YES;
    [self.pickerView addSubview:rectView];
    [rectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(kPickerViewRowHeight * kPhoneWidthRatio);
    }];
    
    LoginActionView *loginView = [[LoginActionView alloc]init];
    self.confirmView = loginView;
    loginView.title = @"确定";
    [loginView setActionBlock:^{
        STRONG_SELF
        DDLogDebug(@"点击确定按钮");
        if (self.item.editions[self.currentIndex]) {
            [self saveEdition:self.item.editions[self.currentIndex] forSubject:self.subject];
        }
    }];
    [self.view addSubview:loginView];
    [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.pickerView.mas_left);
        make.right.mas_equalTo(self.pickerView.mas_right);
        make.bottom.mas_equalTo(-45 * kPhoneWidthRatio );
        make.height.mas_equalTo(50 * kPhoneWidthRatio);
    }];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.text = @"Tips:在个人中心可以更改教材版本";
    self.tipLabel.font = [UIFont systemFontOfSize:12.f];
    self.tipLabel.textColor = [UIColor colorWithHexString:@"69ad0a"];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.confirmView);
        make.top.equalTo(self.confirmView.mas_bottom).offset(9.f * kPhoneWidthRatio);
    }];
    
    if (self.type == ChooseEditionFromType_PersonalCenter) {
        self.tipLabel.hidden = YES;
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
    }else {
        self.tipLabel.hidden = NO;
        [self.pickerView selectRow:self.currentIndex inComponent:0 animated:NO];
    }
    
    if (SCREEN_HEIGHT < 568) {
        [self.topView removeFromSuperview];
        [self.pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(kPickerViewWidth * kPhoneWidthRatio);
            make.height.mas_equalTo(kPickerViewHeight * kPhoneWidthRatio);
        }];
        UILabel *nameLabel = [[UILabel alloc]init];
        nameLabel.text = self.subject.name;
        nameLabel.font = [UIFont boldSystemFontOfSize:30.f];
        nameLabel.textColor = [UIColor colorWithHexString:@"336600"];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:nameLabel];
        
        CGFloat top = SCREEN_HEIGHT/2 - kNavViewHeight * kPhoneWidthRatio - (kPickerViewHeight * kPhoneWidthRatio)/2;
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navView.mas_bottom).offset(top/2 - 20);
            make.centerX.mas_equalTo(0);
        }];
    }
}

- (void)reloadSelectedEdition {
    if (!self.subject.edition || !self.item.editions) {
        return;
    }
    [self.item.editions enumerateObjectsUsingBlock:^(GetEditionRequestItem_edition *edition, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.subject.edition.editionId isEqualToString:edition.editionID]) {
            [self.pickerView selectRow:idx inComponent:0 animated:NO];
            *stop = YES;
        }
    }];
}

- (void)saveEdition:(GetEditionRequestItem_edition *)edition forSubject:(GetSubjectRequestItem_subject *)subject {
    WEAK_SELF
    [self.view nyx_startLoading];
    [[ExerciseSubjectManager sharedInstance]saveEditionWithSubjectID:subject.subjectID editionID:edition.editionID completeBlock:^(GetSubjectRequestItem_subject *retItem, NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
        } else {
            if (self.type == ChooseEditionFromType_ExerciseMain) {
                DDLogDebug(@"跳转到练习界面");
                BLOCK_EXEC(self.successBlock,retItem);
                return;
            }
            if (self.type == ChooseEditionFromType_PersonalCenter) {
                DDLogDebug(@"跳转到教材版本选择界面");
                [self.navigationController popViewControllerAnimated:YES];
                return;
            }
        }
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.item.editions.count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return kPickerViewWidth * kPhoneWidthRatio;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kPickerViewRowHeight * kPhoneWidthRatio ;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    for(UIView *singleLine in pickerView.subviews) {
        if (singleLine.frame.size.height < 1) {
            singleLine.backgroundColor = [UIColor clearColor];
        }
    }
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, row * kPickerViewRowHeight * kPhoneWidthRatio, kPickerViewWidth, kPickerViewRowHeight * kPhoneWidthRatio)];
        label.font = [UIFont boldSystemFontOfSize:23.f];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
    }
    GetEditionRequestItem_edition *edition = self.item.editions[row];
    label.text = edition.name;
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentIndex = row;
}

-(void)setChooseEditionSuccessBlock:(ChooseEditionSuccessBlock)block {
    self.successBlock = block;
}
@end

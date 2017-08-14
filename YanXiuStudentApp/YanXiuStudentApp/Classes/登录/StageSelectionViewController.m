//
//  StageSelectionViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "StageSelectionViewController.h"
#import "SimpleAlertView.h"

@interface StageSelectionViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, assign) BOOL separatorSetupComplete;
@end

@implementation StageSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"选择学段";
    UIButton *naviRightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    [naviRightButton setTitle:@"确定" forState:UIControlStateNormal];
    [naviRightButton setTitleColor:[UIColor colorWithHexString:@"89e00d"] forState:UIControlStateNormal];
    [naviRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [naviRightButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"89e00d"]] forState:UIControlStateHighlighted];
    naviRightButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    naviRightButton.layer.cornerRadius = 6;
    naviRightButton.layer.borderWidth = 2;
    naviRightButton.layer.borderColor = [UIColor colorWithHexString:@"89e00d"].CGColor;
    naviRightButton.clipsToBounds = YES;
    WEAK_SELF
    [[naviRightButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        STRONG_SELF
        [self handleSelectStage];
    }];
    [self nyx_setupRightWithCustomView:naviRightButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupUI {
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(125*kPhoneWidthRatio);
        make.right.mas_equalTo(-125*kPhoneWidthRatio);
        make.height.mas_equalTo(400);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-30);
    }];
    [self.pickerView selectRow:self.currentIndex inComponent:0 animated:NO];
}

- (void)handleSelectStage {
    if (![[YXUserManager sharedManager] isLogin]) {
        BLOCK_EXEC(self.completeBlock,[YXMineManager stageNames][self.currentIndex],[YXMineManager stageIds][self.currentIndex]);
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        NSString *stageID = [YXMineManager stageIds][self.currentIndex];
        if ([stageID isEqualToString:[YXUserManager sharedManager].userModel.stageid]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        WEAK_SELF
        SimpleAlertView *alert = [[SimpleAlertView alloc] init];
        alert.title = @"你确定要更改吗？";
        alert.describe = @"学段更改后，练习将切换到相应学段";
        alert.image = [UIImage imageWithColor:[UIColor redColor] rect:CGRectMake(0, 0, 90, 90)];
        [alert addButtonWithTitle:@"取消" style:SimpleAlertActionStyle_Cancel action:^{
            STRONG_SELF
        }];
        [alert addButtonWithTitle:@"确定" style:SimpleAlertActionStyle_Default action:^{
            STRONG_SELF
            [self changeStage];
        }];
        [alert showInView:self.navigationController.view];
    }
}

- (void)changeStage {
    NSString *stageName = [YXMineManager stageNames][self.currentIndex];
    NSString *stageID = [YXMineManager stageIds][self.currentIndex];
    NSDictionary *param = @{@"stageid": stageID,
                            @"stageName": stageName};
    WEAK_SELF
    [self.view nyx_startLoading];
    [self nyx_disableRightNavigationItem];
    [[YXUpdateUserInfoHelper instance] requestWithType:YXUpdateUserInfoTypeStage param:param completion:^(NSError *error) {
        STRONG_SELF
        [self.view nyx_stopLoading];
        [self nyx_enableRightNavigationItem];
        if (error) {
            [self.view nyx_showToast:error.localizedDescription];
            return;
        }
        BLOCK_EXEC(self.completeBlock,stageName,stageID);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [YXMineManager stageNames].count;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 120;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    if (!self.separatorSetupComplete) {
        for(UIView *singleLine in pickerView.subviews) {
            if (singleLine.frame.size.height < 1) {
                singleLine.backgroundColor = [UIColor colorWithHexString:@"89e00d"];
                CGRect rect = singleLine.frame;
                rect.origin.y -= 1;
                rect.size.height = 2;
                singleLine.frame = rect;
            }
        }
    }
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithHexString:@"333333"];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
    }
    label.text = [YXMineManager stageNames][row];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.currentIndex = row;
}

@end

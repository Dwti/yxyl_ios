//
//  AreaSelectionViewController.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "AreaSelectionViewController.h"
#import "SchoolSearchViewController.h"

@interface AreaSelectionViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) YXProvinceList *provinceList;
@property (nonatomic, strong) YXProvince *currentProvince;
@property (nonatomic, strong) YXCity *currentCity;
@property (nonatomic, strong) YXDistrict *currentDistrict;
@property (nonatomic, assign) BOOL separatorSetupComplete;
@end

@implementation AreaSelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.naviTheme = NavigationBarTheme_White;
    self.navigationItem.title = @"选择省市区县";
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
        BLOCK_EXEC(self.areaSelectionBlock,self.currentProvince,self.currentCity,self.currentDistrict);
        SchoolSearchViewController *vc = [[SchoolSearchViewController alloc]init];
        vc.currentProvince = self.currentProvince;
        vc.currentCity = self.currentCity;
        vc.currentDistrict = self.currentDistrict;
        vc.schoolSearchBlock = self.schoolSearchBlock;
        vc.baseVC = self.baseVC;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self nyx_setupRightWithCustomView:naviRightButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"edf0ee"];
    [self parseProvinceList];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)parseProvinceList {
    if (!self.provinceList || !self.provinceList.provinces) {
        self.provinceList = [[YXProvinceList alloc] init];
        [self.provinceList startParse];
    }
    self.currentProvince = self.provinceList.provinces.firstObject;
    self.currentCity = self.currentProvince.citys.firstObject;
    self.currentDistrict = self.currentCity.districts.firstObject;
}

- (void)setupUI {
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(400);
        make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-30);
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.provinceList.provinces.count;
    }else if (component == 1) {
        return self.currentProvince.citys.count;
    }else {
        return self.currentCity.districts.count;
    }
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return (self.view.width-30)/3-4;
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
    }
    if (component == 0) {
        label.textAlignment = NSTextAlignmentLeft;
        label.text = self.provinceList.provinces[row].name;
    }else if (component == 1) {
        label.textAlignment = NSTextAlignmentCenter;
        label.text = self.currentProvince.citys[row].name;
    }else {
        label.textAlignment = NSTextAlignmentRight;
        label.text = self.currentCity.districts[row].name;
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.currentProvince = self.provinceList.provinces[row];
        self.currentCity = self.currentProvince.citys.firstObject;
        self.currentDistrict = self.currentCity.districts.firstObject;
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }else if (component == 1) {
        self.currentCity = self.currentProvince.citys[row];
        self.currentDistrict = self.currentCity.districts.firstObject;
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:NO];
    }else {
        self.currentDistrict = self.currentCity.districts[row];
    }
}

@end

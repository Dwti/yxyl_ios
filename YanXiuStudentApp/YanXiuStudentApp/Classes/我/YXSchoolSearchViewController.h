//
//  YXSchoolSearchViewController.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXMineBaseViewController.h"
#import "YXProvinceList.h"

@class YXSchool;
@interface YXSchoolSearchViewController : YXMineBaseViewController

@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) void(^selectedSchoolBlock)(YXSchool *school);
@property (nonatomic, assign) BOOL isRegisteringAccount;

@property (nonatomic, strong) YXProvince *province;
@property (nonatomic, strong) YXCity *city;
@property (nonatomic, strong) YXDistrict *district;

@end

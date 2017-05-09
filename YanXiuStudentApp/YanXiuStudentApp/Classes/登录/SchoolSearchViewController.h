//
//  SchoolSearchViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXProvinceList.h"
#import "YXSchoolSearchRequest.h"

@interface SchoolSearchViewController : BaseViewController
@property (nonatomic, strong) YXProvince *currentProvince;
@property (nonatomic, strong) YXCity *currentCity;
@property (nonatomic, strong) YXDistrict *currentDistrict;

@property (nonatomic, strong) void(^schoolSearchBlock)(YXSchool *school);
@property (nonatomic, weak) UIViewController *baseVC;
@end

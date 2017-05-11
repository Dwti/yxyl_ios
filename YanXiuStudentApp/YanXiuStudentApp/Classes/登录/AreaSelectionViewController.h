//
//  AreaSelectionViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "YXSchoolSearchRequest.h"
#import "YXProvinceList.h"

@interface AreaSelectionViewController : BaseViewController
@property (nonatomic, strong) void(^schoolSearchBlock)(YXSchool *school);
@property (nonatomic, strong) void(^areaSelectionBlock)(YXProvince *province,YXCity *city,YXDistrict *district);
@property (nonatomic, weak) UIViewController *baseVC;
@end

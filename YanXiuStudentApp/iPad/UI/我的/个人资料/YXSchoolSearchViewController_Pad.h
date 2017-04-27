//
//  YXSchoolSearchViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXMineBaseViewController_Pad.h"

@class YXSchool;
@interface YXSchoolSearchViewController_Pad : YXMineBaseViewController_Pad

@property (nonatomic, copy) NSString *areaId;
@property (nonatomic, copy) void(^selectedSchoolBlock)(YXSchool *school);
@property (nonatomic, assign) BOOL isRegisteringAccount;

@end

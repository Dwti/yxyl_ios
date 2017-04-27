//
//  YXDistrictSelectViewController.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/9.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXAreaBaseViewController.h"

@class YXProvince, YXCity;
@interface YXDistrictSelectViewController : YXAreaBaseViewController

- (instancetype)initWithProvince:(YXProvince *)province
                            city:(YXCity *)city;

@end

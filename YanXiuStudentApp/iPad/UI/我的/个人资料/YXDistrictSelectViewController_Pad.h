//
//  YXDistrictSelectViewController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXAreaBaseViewController_Pad.h"

@class YXProvince, YXCity;
@interface YXDistrictSelectViewController_Pad : YXAreaBaseViewController_Pad

- (instancetype)initWithProvince:(YXProvince *)province
                            city:(YXCity *)city;
@end

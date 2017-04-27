//
//  LaunchAppItem.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/19/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXRecordBase.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface LaunchAppItem : YXRecordBase
@property (nonatomic, copy) NSString *mobileModel; // 手机型号
@property (nonatomic, copy) NSString *brand;       // 品牌
@property (nonatomic, copy) NSString *system;      // 系统
@property (nonatomic, copy) NSString *resolution;  // 分辨率
@property (nonatomic, copy) NSString *netModel;    // 联网方式 0：WIFI；2：4G；3：3G；4：2G，5:其它

+ (NSString *)networkStatus;
+ (NSString *)screenResolution;

@end

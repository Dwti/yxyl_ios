//
//  YXProvinceList.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/14.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXDistrict : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *did;

@end

@interface YXCity : NSObject

@property (nonatomic, copy) NSString *cid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *districts;

@end

@interface YXProvince : NSObject

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSMutableArray *citys;

@end

// 省市区（县）
@interface YXProvinceList : NSObject

@property (nonatomic, strong) NSMutableArray *provinces;

- (BOOL)startParse;

@property (nonatomic, strong) YXProvince *currentProvince;
@property (nonatomic, strong) YXCity *currentCity;
@property (nonatomic, strong) YXDistrict *currentDistrict;

@end


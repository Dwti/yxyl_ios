//
//  YXSchoolSearchRequest.h
//  YanXiuApp
//
//  Created by ChenJianjun on 15/6/11.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "YXCommonPageModel.h"

@interface YXSchool : JSONModel

@property (nonatomic, copy) NSString<Optional> *areaId;
@property (nonatomic, copy) NSString<Optional> *cityId;
@property (nonatomic, copy) NSString<Optional> *sid;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *provinceId;

@end

@protocol YXSchool @end
@interface YXSchoolSearchItem : HttpBaseRequestItem

@property (nonatomic, copy) YXCommonPageModel<Optional> *page;
@property (nonatomic, copy) NSArray<YXSchool, Optional> *data;

@end

// 搜索学校
@interface YXSchoolSearchRequest : YXGetRequest

@property (nonatomic, strong) NSString<Optional> *school;   //学校名
@property (nonatomic, strong) NSString<Optional> *regionId; //所在地区Id

@end

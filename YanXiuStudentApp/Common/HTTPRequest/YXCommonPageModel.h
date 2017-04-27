//
//  YXCommonPageModel.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/13.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "JSONModel.h"

@interface YXCommonPageModel : JSONModel

@property (nonatomic, copy) NSString<Optional> *nextPage;
@property (nonatomic, copy) NSString<Optional> *pageSize;
@property (nonatomic, copy) NSString<Optional> *totalCou;
@property (nonatomic, copy) NSString<Optional> *totalPage;

@end

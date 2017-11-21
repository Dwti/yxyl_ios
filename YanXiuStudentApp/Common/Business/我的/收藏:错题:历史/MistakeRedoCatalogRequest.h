//
//  MistakeRedoCatalogRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/3/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@protocol MistakeRedoCatalogRequestItem_data <NSObject>

@end

@interface MistakeRedoCatalogRequestItem_data : JSONModel
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSArray *wqnumbers;
@end

@interface MistakeRedoCatalogRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<MistakeRedoCatalogRequestItem_data,Optional> *data;
@end

@interface MistakeRedoCatalogRequest : YXGetRequest
@property (nonatomic, strong) NSString *stageId;
@property (nonatomic, strong) NSString *subjectId;
@property (nonatomic, strong) NSString *qids;

@end

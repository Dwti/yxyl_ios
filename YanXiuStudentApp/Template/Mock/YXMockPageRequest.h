//
//  YXMockPageRequest.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 7/9/15.
//  Copyright (c) 2015 yanxiu.com. All rights reserved.
//

#import "GetRequest.h"

@interface YXMockPageRequestItem : NSObject
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSArray *dataArray;
@end

@interface YXMockPageRequest : GetRequest
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, assign) NSInteger pagesize; // 默认20个

@property (nonatomic, assign) NSInteger mockTotal;
@end

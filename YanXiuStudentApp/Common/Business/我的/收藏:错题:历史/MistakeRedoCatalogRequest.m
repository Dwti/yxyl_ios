//
//  MistakeRedoCatalogRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/3/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "MistakeRedoCatalogRequest.h"

@implementation MistakeRedoCatalogRequestItem_data

@end

@implementation MistakeRedoCatalogRequestItem

@end

@implementation MistakeRedoCatalogRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getReDoCatalog.do"];
    }
    return self;
}
@end

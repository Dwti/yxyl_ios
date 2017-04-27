//
//  YXUploadHeadImgRequest.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/8/17.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXUploadHeadImgRequest.h"

@implementation YXUploadHeadImgItem_Data

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"hid":@"id"}];
}

@end

@implementation YXUploadHeadImgItem

@end

@implementation YXUploadHeadImgRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/common/uploadHeadImg.do"];
        self.urlHead = [NSString stringWithFormat:@"%@?token=%@", self.urlHead, self.token];
    }
    return self;
}

@end


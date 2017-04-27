//
//  YXUploadImageRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/10/8.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXUploadImageRequest.h"

@implementation YXUploadImageRequestItem

@end

@implementation YXUploadImageRequest

- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/common/uploadImgs.do"];
    }
    return self;
}

@end

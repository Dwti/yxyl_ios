//
//  VerifyBindedMobileRequest.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 4/5/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "VerifyBindedMobileRequest.h"

@implementation VerifyBindedMobileRequest
- (instancetype)init
{
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].loginServer stringByAppendingString:@"app/user/checkMobileMsgCode.do"];
    }
    return self;
}
@end

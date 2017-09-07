//
//  SaveFavVolumeRequest.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/9/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "SaveFavVolumeRequest.h"

@implementation SaveFavVolumeRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/common/saveFavVolume.do"];
    }
    return self;
}
@end

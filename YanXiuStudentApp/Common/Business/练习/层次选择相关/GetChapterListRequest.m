//
//  GetChapterListRequest.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "GetChapterListRequest.h"

@implementation GetChapterListRequestItem_chapter
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"chapterID":@"id"
                                                                  }];
}

- (NSArray *)subNodes{
    return self.children;
}

- (void)setSubNodes:(NSArray *)subNodes {
    self.children = (NSArray<GetChapterListRequestItem_chapter,Optional> *)subNodes;
}
@end

@implementation GetChapterListRequestItem
+ (JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"chapters":@"data"}];
}
@end

@implementation GetChapterListRequest
- (instancetype)init {
    if (self = [super init]) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/common/getChapterList.do"];
    }
    return self;
}

@end

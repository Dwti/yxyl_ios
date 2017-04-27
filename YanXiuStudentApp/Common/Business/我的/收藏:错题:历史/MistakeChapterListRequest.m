//
//  MistakeChapterListRequest.m
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "MistakeChapterListRequest.h"


@implementation MistakeChapterListRequestItem_chapter
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"chapterID" : @"id",
                                                                  @"count" : @"question_num"
                                                                  }];
}
- (NSArray *)subNodes {
    return self.children;
}

- (void)setSubNodes:(NSArray *)subNodes {
    self.children = (NSArray<MistakeChapterListRequestItem_chapter, Optional> *)subNodes;
}

@end


@implementation MistakeChapterListRequestItem
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{@"chapters":@"data"}];
}
@end


@implementation MistakeChapterListRequest
- (instancetype)init {
    self = [super init];
    if (self) {
        self.urlHead = [[YXConfigManager sharedInstance].server stringByAppendingString:@"app/q/getWrongQChapterList.do"];
    }
    return self;
}
@end

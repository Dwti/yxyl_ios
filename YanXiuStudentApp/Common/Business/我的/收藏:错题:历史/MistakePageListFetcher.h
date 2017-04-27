//
//  MistakePageListFetcher.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "PagedListFetcherBase.h"

@interface MistakePageListFetcher : PagedListFetcherBase
@property (nonatomic, copy) void (^error)(NSError *error);
@property (nonatomic, strong) NSString *subjectID;
@property (nonatomic, strong) NSArray *qids;
@property (nonatomic, copy) NSString *currentID;

- (void)startWithMistakeBlock:(void(^)(int total, YXIntelligenceQuestionListItem *retItem, NSError *error))aCompleteBlock;
@end

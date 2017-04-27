//
//  MistakeChapterTreeDataFetcher.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "TreeDataFetcher.h"

@interface MistakeChapterTreeDataFetcher : TreeDataFetcher
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *editionId;
@end

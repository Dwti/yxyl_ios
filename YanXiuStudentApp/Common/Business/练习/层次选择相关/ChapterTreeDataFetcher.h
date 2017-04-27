//
//  ChapterTreeDataFetcher.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "TreeDataFetcher.h"

@interface ChapterTreeDataFetcher : TreeDataFetcher
@property (nonatomic, copy) NSString *volumeID;
@property (nonatomic, copy) NSString *subjectID;
@property (nonatomic, copy) NSString *editionID;
@end

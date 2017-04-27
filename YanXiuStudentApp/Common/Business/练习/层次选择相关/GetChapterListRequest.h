//
//  GetChapterListRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "TreeNodeProtocol.h"

@protocol GetChapterListRequestItem_chapter <NSObject>
@end
@interface GetChapterListRequestItem_chapter : JSONModel<TreeNodeProtocol>
@property (nonatomic, copy) NSString<Optional> *chapterID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, strong) NSArray<GetChapterListRequestItem_chapter,Optional> *children;
@end

@interface GetChapterListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetChapterListRequestItem_chapter,Optional> *chapters;
@end

@interface GetChapterListRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *volume;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *editionId;
@end

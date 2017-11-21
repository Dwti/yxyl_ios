//
//  MistakeKnpListRequest.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/31/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "TreeNodeProtocol.h"

@protocol MistakeKnpListRequestItem_knp <NSObject>
@end


@interface MistakeKnpListRequestItem_knp : JSONModel<TreeNodeProtocol>
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *knpID;
@property (nonatomic, copy) NSString<Optional> *count;
@property (nonatomic, strong) NSArray<Optional> *qids;
@property (nonatomic, strong) NSArray<MistakeKnpListRequestItem_knp, Optional> *children;
@end


@interface MistakeKnpListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<MistakeKnpListRequestItem_knp, Optional> *knps;
@end


@interface MistakeKnpListRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *subjectId;
@end


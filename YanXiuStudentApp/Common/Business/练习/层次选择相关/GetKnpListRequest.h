//
//  GetKnpListRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"
#import "TreeNodeProtocol.h"

@interface GetKnpListRequestItem_knp_data : JSONModel
@property (nonatomic, copy) NSString<Optional> *masterNum;
@property (nonatomic, copy) NSString<Optional> *totalNum;
@property (nonatomic, copy) NSString<Optional> *avgMasterRate;
@property (nonatomic, copy) NSString<Optional> *masterLevel;
@end

@protocol GetKnpListRequestItem_knp <NSObject>
@end
@interface GetKnpListRequestItem_knp : JSONModel<TreeNodeProtocol>
@property (nonatomic, copy) NSString<Optional> *knpID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, strong) GetKnpListRequestItem_knp_data<Optional> *data;
@property (nonatomic, strong) NSArray<GetKnpListRequestItem_knp,Optional> *children;
@end

@interface GetKnpListRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetKnpListRequestItem_knp,Optional> *knps;
@end

@interface GetKnpListRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *subjectId;
@end

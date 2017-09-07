//
//  GetVolumesRequest.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/9/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@protocol GetVolumesRequestItem_volume <NSObject>
@end

@interface GetVolumesRequestItem_volume: JSONModel
@property (nonatomic, copy) NSString<Optional> *volumeID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, copy) NSString<Optional> *selected;
@end


@interface GetVolumesRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetVolumesRequestItem_volume,Optional> *volumes;
@end

@interface GetVolumesRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *editionId;

@end

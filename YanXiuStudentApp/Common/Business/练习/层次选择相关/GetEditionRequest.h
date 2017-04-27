//
//  GetEditionRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/10/25.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface GetEditionRequestItem_edition_data : JSONModel
@property (nonatomic, copy) NSString<Optional> *has_knp;
@end

@protocol GetEditionRequestItem_edition_volume <NSObject>
@end
@interface GetEditionRequestItem_edition_volume : JSONModel
@property (nonatomic, copy) NSString<Optional> *volumeID;
@property (nonatomic, copy) NSString<Optional> *name;
@end

@protocol GetEditionRequestItem_edition <NSObject>
@end
@interface GetEditionRequestItem_edition : JSONModel
@property (nonatomic, copy) NSString<Optional> *editionID;
@property (nonatomic, copy) NSString<Optional> *name;
@property (nonatomic, strong) GetEditionRequestItem_edition_data<Optional> *data;
@property (nonatomic, strong) NSArray<GetEditionRequestItem_edition_volume,Optional> *volumes;
@end

@interface GetEditionRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<GetEditionRequestItem_edition,Optional> *editions;
@end

@interface GetEditionRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *subjectId;
@end

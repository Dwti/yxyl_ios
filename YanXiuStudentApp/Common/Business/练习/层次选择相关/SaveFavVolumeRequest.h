//
//  SaveFavVolumeRequest.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/9/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXGetRequest.h"

@interface SaveFavVolumeRequest : YXGetRequest
@property (nonatomic, copy) NSString *stageId;
@property (nonatomic, copy) NSString *subjectId;
@property (nonatomic, copy) NSString *volumeId;

@end

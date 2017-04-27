//
//  YXUploadHeadImgRequest.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/8/17.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXPostRequest.h"

@interface YXUploadHeadImgItem_Data : JSONModel

@property (nonatomic, copy) NSString<Optional> *hid;
@property (nonatomic, copy) NSString<Optional> *head;

@end

@protocol YXUploadHeadImgItem_Data <NSObject> @end

@interface YXUploadHeadImgItem : HttpBaseRequestItem

@property (nonatomic, copy) NSArray<YXUploadHeadImgItem_Data, Optional> *data;

@end

@interface YXUploadHeadImgRequest : YXPostRequest
@end

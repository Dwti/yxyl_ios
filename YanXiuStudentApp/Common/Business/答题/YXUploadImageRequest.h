//
//  YXUploadImageRequest.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/10/8.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import "YXUploadRequest.h"

@interface YXUploadImageRequestItem : HttpBaseRequestItem
@property (nonatomic, strong) NSArray<Optional> *data; // url 地址的数组
@end

@interface YXUploadImageRequest : YXUploadRequest

@end

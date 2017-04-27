//
//  YXQAUploadImageManager.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/18.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^UploadImageProgressBlock) (NSInteger index, NSInteger total);

@interface YXQAUploadImageManager : NSObject

+ (instancetype)sharedInstance;

/**
 *  上传答题里面的图片，目前仅主观题有图片
 *
 *  @param model         答题的model
 *  @param completeBlock 上传结果的回调
 */
- (void)uploadImageInModel:(QAPaperModel *)model completeBlock:(void(^)(NSError *error))completeBlock;

/**
 *  停止上传
 */
- (void)stopUploadImage;

- (void)setUploadImageBlock:(UploadImageProgressBlock)block;

@end

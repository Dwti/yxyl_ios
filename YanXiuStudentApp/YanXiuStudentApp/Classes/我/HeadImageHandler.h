//
//  HeadImageHandler.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HeadImageHandler : NSObject
- (void)pickImageFromCameraWithCompleteBlock:(void(^)(UIImage *image))completeBlock;
- (void)pickImageFromAlbumWithCompleteBlock:(void(^)(UIImage *image))completeBlock;
@end

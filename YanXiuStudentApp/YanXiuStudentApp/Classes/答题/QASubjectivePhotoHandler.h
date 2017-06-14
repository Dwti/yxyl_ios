//
//  QASubjectivePhotoHandler.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QASubjectivePhotoHandler : NSObject
- (void)addPhotoWithCompleteBlock:(void(^)(UIImage *image))completeBlock;
- (void)browsePhotos:(NSMutableArray<QAImageAnswer *> *)photos oriIndex:(NSInteger)index editable:(BOOL)editable deleteBlock:(void(^)())deleteBlock;
@end

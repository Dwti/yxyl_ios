//
//  ImageUploadProgressView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/11/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ImageUploadType) {
    ImageUpload_Submit,
    ImageUpload_Save
};

typedef void(^CloseBlock) (void);

@interface ImageUploadProgressView : UIView
@property (nonatomic, assign) ImageUploadType type;
- (void)setupCloseBlock:(CloseBlock)block;
- (void)updateWithUploadedCount:(NSInteger)uploadedCount totalCount:(NSInteger)totalCount;
@end

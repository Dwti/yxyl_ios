//
//  YXImagePickerController_Pad.h
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YXImagePickerController_Pad : NSObject

@property (nonatomic, assign) BOOL isShow;

+ (instancetype)instance;

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void(^)(UIImage *selectedImage))completion;

@end

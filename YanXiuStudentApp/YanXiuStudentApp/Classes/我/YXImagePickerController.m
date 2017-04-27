//
//  YXImagePickerController.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 15/7/8.
//  Copyright (c) 2015年 yanxiu.com. All rights reserved.
//

#import "YXImagePickerController.h"
#import <AVFoundation/AVFoundation.h>

@interface YXImagePickerController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) void (^completion)(UIImage *selectedImage);

@end

@implementation YXImagePickerController

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *))completion
{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied
            || authStatus == AVAuthorizationStatusRestricted) {
            [viewController yx_showToast:@"相机权限受限\n请在设置-隐私-相机中开启"];
            return;
        }
        self.imagePickerController.sourceType = sourceType;
        self.completion = completion;
        [viewController presentViewController:self.imagePickerController animated:YES completion:nil];
    } else {
        [viewController yx_showToast:@"设备不支持拍照功能！"];
    }
}

- (UIImagePickerController *)imagePickerController
{
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    return _imagePickerController;
}

#pragma mark -

- (void)completionImagePick:(UIImagePickerController *)picker image:(UIImage *)image
{
    if (self.completion) {
        self.completion(image);
    }
    if (picker) {
        [picker dismissViewControllerAnimated:YES
                                   completion:nil];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self completionImagePick:picker image:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self completionImagePick:picker image:nil];
}

@end

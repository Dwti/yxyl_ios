//
//  YXImagePickerController_Pad.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXImagePickerController_Pad.h"
#import <AVFoundation/AVFoundation.h>
#import "YXAppStartupManager.h"
#import "UIImagePickerController+YXNonRotating.h"

@interface YXImagePickerController_Pad ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, copy) void (^completion)(UIImage *selectedImage);

@end

@implementation YXImagePickerController_Pad

+ (instancetype)instance
{
    static YXImagePickerController_Pad *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YXImagePickerController_Pad alloc] init];
    });
    return instance;
}

- (void)pickImageWithSourceType:(UIImagePickerControllerSourceType)sourceType
                     completion:(void (^)(UIImage *))completion
{
    UIViewController *viewController = [YXAppStartupManager sharedInstance].window.rootViewController;
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusDenied
            || authStatus == AVAuthorizationStatusRestricted) {
            [viewController yx_showToast:@"相机权限受限\n请在设置-隐私-相机中开启"];
            return;
        }
        [YXImagePickerController_Pad instance].isShow = YES;
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
        [YXImagePickerController_Pad instance].isShow = NO;
        [picker dismissViewControllerAnimated:YES
                                   completion:nil];
    }
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self completionImagePick:picker image:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self completionImagePick:picker image:nil];
}

@end

//
//  QASubjectivePhotoHandler.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QASubjectivePhotoHandler.h"
#import "QACameraOverlayView.h"
#import "QAPhotoSelectionViewController.h"
#import "QAPhotoClipViewController.h"
#import "QAPhotoBrowseViewController.h"
#import "UIViewController+VisibleViewController.h"

@interface QASubjectivePhotoHandler()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) YXNavigationController *photoSelectionNavi;
@property (nonatomic, strong) void(^addPhotoBlock)(UIImage *image);
@property (nonatomic, strong) void(^deleteBlock)();
@end

@implementation QASubjectivePhotoHandler
#pragma mark - 照片选取
- (void)addPhotoWithCompleteBlock:(void(^)(UIImage *image))completeBlock {
    self.addPhotoBlock = completeBlock;
    [self showCamera];
}

- (void)showCamera {
    UIViewController *vc = [[UIApplication sharedApplication].keyWindow.rootViewController nyx_visibleViewController];
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:nil];
        return;
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [self showAlertWithTitle:@"相机权限被禁用，请到设置中允许易学易练使用相机" rootVC:vc];
        return;
    }
    
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.navigationBarHidden = YES;
    self.imagePickerController.edgesForExtendedLayout = UIRectEdgeAll;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePickerController.delegate = self;
    self.imagePickerController.showsCameraControls = NO;
    NSMutableArray* mediaTypes = [[NSMutableArray alloc] init];
    [mediaTypes addObject: (__bridge NSString*) kUTTypeImage];
    self.imagePickerController.mediaTypes = mediaTypes;
    
    QACameraOverlayView *overlayView = [[QACameraOverlayView alloc]initWithFrame:self.imagePickerController.view.bounds];
    WEAK_SELF
    [overlayView setAlbumBlock:^{
        STRONG_SELF
        [self showAlbum];
    }];
    [overlayView setCameraBlock:^{
        STRONG_SELF
        [self.imagePickerController takePicture];
    }];
    [overlayView setExitBlock:^{
        STRONG_SELF
        [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    }];
 
    UIView *v = [UIView new];
    v.frame = [UIScreen mainScreen].bounds;
    v.backgroundColor = [UIColor blackColor];
    
    self.imagePickerController.cameraOverlayView = v;
    [vc presentViewController: self.imagePickerController animated: YES completion: ^{
        CGSize screenBounds = [UIScreen mainScreen].bounds.size;
        CGFloat cameraAspectRatio = 4.0f/3.0f;
        CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
        CGFloat scale = screenBounds.height / camViewHeight;
        self.imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        self.imagePickerController.cameraViewTransform = CGAffineTransformScale(self.imagePickerController.cameraViewTransform, scale, scale);
        self.imagePickerController.cameraOverlayView = overlayView;
    }];
}

- (void)showAlbum {
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == AVAuthorizationStatusNotDetermined){
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (*stop) {
                // TODO:...
                return;
            }
            *stop = TRUE;//不能省略
        } failureBlock:^(NSError *error) {
            NSLog(@"failureBlock");
        }];
        return;
    } else if (author ==kCLAuthorizationStatusRestricted || author ==kCLAuthorizationStatusDenied){
        [self showAlertWithTitle:@"照片访问权限被禁用，请到设置中允许易学易练访问照片" rootVC:self.imagePickerController];
        return;
    }
    
    if (!self.photoSelectionNavi) {
        QAPhotoSelectionViewController *vc = [[QAPhotoSelectionViewController alloc]init];
        WEAK_SELF
        [vc setImageSelectionBlock:^(UIImage *image){
            STRONG_SELF
            [self goClipVCWithImage:image baseNavi:self.photoSelectionNavi];
        }];
        [vc setExitBlock:^{
            STRONG_SELF
            [UIView animateWithDuration:0.2 animations:^{
                self.photoSelectionNavi.view.frame = CGRectMake(0, self.imagePickerController.view.height, self.imagePickerController.view.width, self.imagePickerController.view.height);
            }];
        }];
        YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:vc];
        self.photoSelectionNavi = navi;
    }
    [self.photoSelectionNavi popToRootViewControllerAnimated:NO];
    [self.imagePickerController.view addSubview:self.photoSelectionNavi.view];
    self.photoSelectionNavi.view.frame = CGRectMake(0, self.imagePickerController.view.height, self.imagePickerController.view.width, self.imagePickerController.view.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.photoSelectionNavi.view.frame = self.imagePickerController.view.bounds;
    }];
}

- (void)goClipVCWithImage:(UIImage *)image baseNavi:(UINavigationController *)baseNavi{
    QAPhotoClipViewController *vc = [[QAPhotoClipViewController alloc]init];
    vc.oriImage = image;
    WEAK_SELF
    [vc setClippedBlock:^(UIImage *clippedImage){
        STRONG_SELF
        [self.imagePickerController.presentingViewController dismissViewControllerAnimated:NO completion:nil];
        BLOCK_EXEC(self.addPhotoBlock,clippedImage);
    }];
    [baseNavi pushViewController:vc animated:YES];
}

- (void)showAlertWithTitle:(NSString *)title rootVC:(UIViewController *)vc {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle: title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *edit = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:edit];
    [alert addAction:cancel];
    
    [vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UIImagePickerController delegte
- (void)imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info {
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self goClipVCWithImage:image baseNavi:self.imagePickerController];
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController*) picker {
    [picker dismissViewControllerAnimated: YES completion: ^{}];
}

#pragma mark - 照片浏览
- (void)browsePhotos:(NSMutableArray<QAImageAnswer *> *)photos oriIndex:(NSInteger)index editable:(BOOL)editable deleteBlock:(void(^)())deleteBlock {
    self.deleteBlock = deleteBlock;
    QAPhotoBrowseViewController *vc = [[QAPhotoBrowseViewController alloc]init];
    vc.itemArray = photos;
    vc.oriIndex = index;
    vc.canDelete = editable;
    WEAK_SELF
    [vc setDeleteBlock:^{
        STRONG_SELF
        BLOCK_EXEC(self.deleteBlock);
    }];
    UIViewController *baseVC = [[UIApplication sharedApplication].keyWindow.rootViewController nyx_visibleViewController];
    [baseVC.navigationController pushViewController:vc animated:YES];
}

@end

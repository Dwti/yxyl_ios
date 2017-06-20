//
//  YXQASubjectiveAddPhotoHandler.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQASubjectiveAddPhotoHandler.h"
#import "UIImage+YXImage.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YXPhotoModel.h"
#import "EditPictureViewController.h"
#import "CameraView.h"
#import "PrefixHeader.pch"
#import <AVFoundation/AVCaptureDevice.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoAssetManager.h"
#import "PhotoListViewController.h"
#import "PhotoAssetUtils.h"

@interface YXQASubjectiveAddPhotoHandler ()<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>
@property (nonatomic, strong) MWPhotoBrowser * photoBrowser;
@property (nonatomic, strong) YXAlbumViewModel* albumViewModel;
@property (nonatomic, assign) CGSize originImageSize;
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) PhotoListViewController *photoListVC;
@end

@implementation YXQASubjectiveAddPhotoHandler

- (instancetype)initWithViewController:(UIViewController *)vc{
    if (self = [super init]) {
        self.vc = vc;
    }
    return self;
}

- (void)showDeleteActionSheet {
    EEAlertView *alertView = [[EEAlertView alloc] init];
    alertView.title = @"是否删除图片?";
    WEAK_SELF
    [alertView addButtonWithTitle:@"取消" action:nil];
    [alertView addButtonWithTitle:@"删除" action:^{
        STRONG_SELF
        if (self.albumViewModel.currentPositonPhoto < [self.albumViewModel.selectPhotoArray count]) {
            [self.albumViewModel selectPhotoArrayDelegateObject:self.albumViewModel.selectPhotoArray[self.albumViewModel.currentPositonPhoto]];
        }
        if ([self.albumViewModel.selectPhotoArray count] <= 0) {
            [self.photoBrowser.navigationController popViewControllerAnimated:YES];
            return ;
        }else{
            [self.photoBrowser reloadData];
            NSString *title = [self browserTitleWithCurrentIndex:self.albumViewModel.currentPositonPhoto total:self.albumViewModel.selectPhotoArray.count];
            self.photoBrowser.title = title;
        }
    }];
    
    [alertView showInView:self.vc.navigationController.view];
}

- (void)showCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        DDLogDebug(@"设备不支持拍照");
        return;
    }
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:nil];
        return;
    } else if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        [self showAlertWithTitle:@"相机访问权限被禁用，请到设置中允许易学易练访问相机"];
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
    
    CameraView *cameraView = [CameraView new];
    cameraView.frame = self.imagePickerController.view.frame;
    WEAK_SELF
    [cameraView setAlbum:^{
        STRONG_SELF
        [self showAlbum];
    }];
    [cameraView setCamera:^{
        [self.imagePickerController takePicture];
    }];
    
    UIView *v = [UIView new];
    v.frame = [UIScreen mainScreen].bounds;
    v.backgroundColor = [UIColor blackColor];
    self.imagePickerController.cameraOverlayView = v;
    [self.vc presentViewController: self.imagePickerController animated: YES completion: ^{
        CGSize screenBounds = [UIScreen mainScreen].bounds.size;
        CGFloat cameraAspectRatio = 4.0f/3.0f;
        CGFloat camViewHeight = screenBounds.width * cameraAspectRatio;
        CGFloat scale = screenBounds.height / camViewHeight;
        self.imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0, (screenBounds.height - camViewHeight) / 2.0);
        self.imagePickerController.cameraViewTransform = CGAffineTransformScale(self.imagePickerController.cameraViewTransform, scale, scale);
        self.imagePickerController.cameraOverlayView = cameraView;
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
        [self showAlertWithTitle:@"照片访问权限被禁用，请到设置中允许易学易练访问照片"];
        return;
    }
    
    WEAK_SELF
    [[PhotoAssetManager shareManager] getGroupList:^(NSArray *resultArray) {
        STRONG_SELF
        self.photoListVC = [[PhotoListViewController alloc] initWithAlbumArray:resultArray];
        [self.photoListVC setPhotoDidSelectBlock:^(UIImage *img) {
            STRONG_SELF
            [self showEditPicViewControllerWithImage:img rootVC:self.photoListVC];
        }];
    
        YXNavigationController *navi = [[YXNavigationController alloc] initWithRootViewController:self.photoListVC];
        [self.imagePickerController presentViewController:navi animated:YES completion:nil];
    }];
}

- (void)showEditPicViewControllerWithImage:(UIImage *)image rootVC:(UIViewController *)rootVC {
    image = [image scaleToSize:[self getImageSizeWithImage:image]];
    self.originImageSize = image.size;
    
    EditPictureViewController *vc = [[EditPictureViewController alloc] init];
    vc.image = image;
    
    WEAK_SELF
    [vc setCancel:^{
        STRONG_SELF
        if ([rootVC isKindOfClass:[PhotoListViewController class]]) {
            [self.photoListVC dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self showCamera];
        }
    }];
    
    [vc setEditComplete:^(UIImage *image) {
        if ([rootVC isKindOfClass:[PhotoListViewController class]]) {
            [self.vc dismissViewControllerAnimated:YES completion:nil];
        }
        
        STRONG_SELF
        if (!CGSizeEqualToSize(self.originImageSize, image.size)) {
            self.originImageSize = CGSizeZero;
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                if (!error) {
                }
            }];
        }
        YXPhotoModel * photoModel = [[YXPhotoModel alloc] initWithImage:image];
        photoModel.thumbImage = image;
        photoModel.isSelect = YES;
        [self.albumViewModel selectPhotoArrayAddObject: photoModel];
    }];
    
    [rootVC.navigationController pushViewController:vc animated:YES];
}

- (void)showAlertWithTitle:(NSString *)title {
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
    
    if ([title rangeOfString:@"相机"].location != NSNotFound) {
        [self.vc presentViewController:alert animated:YES completion:nil];
    }else if(self.imagePickerController){
        [self.imagePickerController presentViewController:alert animated:YES completion:nil];
    }
}

- (CGSize)getImageSizeWithImage:(UIImage *)image {
    CGSize gSize;
    CGSize size = image.size;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    gSize.width = screenSize.width;
    gSize.height = gSize.width/(size.width/size.height);
    return gSize;
}

- (CGSize)getImageHaveNavigationBarSizeWithImage:(UIImage *)image {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height - 64;
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    if (imageWidth <= width && imageHeight <= height) {//顶不到屏幕边就放大
//        CGFloat scale = width / imageWidth;
//        if (imageHeight * scale > height) {
//            scale = height / imageHeight;
//        }
//        CGSize size = CGSizeMake(imageWidth * scale, imageHeight * scale);
        return image.size;
    }else{//超过屏幕就缩小
        CGFloat scale = imageWidth / width;
        if (imageHeight / height > scale) {
            scale = imageHeight / height;
        }
        width = imageWidth / scale;
        height = imageHeight / scale;
        return CGSizeMake(width, height);
    }
}

- (NSString *)browserTitleWithCurrentIndex: (NSInteger)currentIndex total:(NSInteger)total {
    return [NSString stringWithFormat:@"%@/%@",@(currentIndex+1),@(total)];
}


#pragma mark - YXQASubjectiveAddPhotoDelegate
- (void)addPhotoWithViewModel:(YXAlbumViewModel *)viewModel {
    self.albumViewModel = viewModel;
    [self showCamera];
}

- (void)photoClickedWithModel:(YXAlbumViewModel *)viewModel index:(NSInteger)index canDelete:(BOOL)canDelete {
    self.albumViewModel = viewModel;
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoBrowserWithTitle:currentIndex:canDelete:)]) {
        NSString *title = [self browserTitleWithCurrentIndex:index total:self.albumViewModel.selectPhotoArray.count];
        MWPhotoBrowser *photoBrowser = [self.delegate photoBrowserWithTitle:title currentIndex:index canDelete:canDelete];
        self.photoBrowser = photoBrowser;
        photoBrowser.zoomPhotosToFill = NO;
        [self.vc.navigationController pushViewController:photoBrowser animated:YES];
    }
}

#pragma mark - UIImagePickerController delegte
- (void) imagePickerController: (UIImagePickerController*) picker didFinishPickingMediaWithInfo: (NSDictionary*) info {
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self showEditPicViewControllerWithImage:image rootVC:self.vc];
    [picker dismissViewControllerAnimated: NO completion:nil];
}

- (void)imagePickerControllerDidCancel: (UIImagePickerController*) picker {
    [self.vc dismissViewControllerAnimated: YES completion: ^{}];
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.albumViewModel.selectPhotoArray count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    DDLogDebug(@"%@", @(index));
    if (index < [self.albumViewModel.selectPhotoArray count]) {
        YXPhotoModel * model = self.albumViewModel.selectPhotoArray[index];
        return model;
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    self.albumViewModel.currentPositonPhoto = index;
    NSString *title = [self browserTitleWithCurrentIndex:index total:self.albumViewModel.selectPhotoArray.count];
    self.photoBrowser.title = title;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return [self browserTitleWithCurrentIndex:(index + 1) total:self.albumViewModel.selectPhotoArray.count];
}

@end

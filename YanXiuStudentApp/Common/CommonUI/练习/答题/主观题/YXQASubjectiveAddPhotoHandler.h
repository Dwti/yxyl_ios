//
//  YXQASubjectiveAddPhotoHandler.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXQASubjectiveAddPhotoDelegate.h"

@protocol YXQASubjectiveAddPhotoHandlerDelegate <NSObject>
@optional
- (UIViewController *)photoListVCWithViewModel:(YXAlbumViewModel *)viewModel title:(NSString *)title;
- (MWPhotoBrowser *)photoBrowserWithTitle:(NSString *)title currentIndex:(NSInteger)index canDelete:(BOOL)canDelete;

@end


@interface YXQASubjectiveAddPhotoHandler : NSObject<
YXQASubjectiveAddPhotoDelegate,
MWPhotoBrowserDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>

@property (nonatomic, weak) id<YXQASubjectiveAddPhotoHandlerDelegate> delegate;
- (instancetype)initWithViewController:(UIViewController *)vc;
- (void)showDeleteActionSheet;

@end

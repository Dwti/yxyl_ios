//
//  YXPhotoListViewController.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/17.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXAlbumViewModel;
@interface YXPhotoListViewController : BaseViewController
- (instancetype)initWithViewModel:(YXAlbumViewModel *)viewModel;
- (instancetype)initWithPhotoArray:(NSArray *)photoArray;
@end

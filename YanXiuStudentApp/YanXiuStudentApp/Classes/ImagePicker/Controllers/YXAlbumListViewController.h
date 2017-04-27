//
//  YXAlbumListViewController.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/17.
//  Copyright (c) 2015年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAlbumViewModel.h"

@class YXAlbumViewModel;

@interface YXAlbumListViewController : BaseViewController
- (instancetype)initWithViewModel:(YXAlbumViewModel *)viewModel;
- (instancetype)initWithAlbumArray:(NSArray *)albumArray;
@end

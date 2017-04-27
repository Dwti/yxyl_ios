//
//  YXPhotoModel.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/22.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "MWPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface YXPhotoModel : MWPhoto

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) NSString *thumbImageUrl;
@property (nonatomic, strong) ALAsset *photoAsset;
@property(nonatomic, assign) BOOL isSelect;

@end

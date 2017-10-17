//
//  QAPhotoSelectionCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface QAPhotoItem : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *image;
@end

@interface QAPhotoSelectionCell : UICollectionViewCell
@property (nonatomic, strong) QAPhotoItem *photoItem;
@property (nonatomic, strong) void(^clickBlock)(void);
@end

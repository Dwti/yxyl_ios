//
//  YXPhotoCollectionViewCell.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/22.
//  Copyright © 2015年 wd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXPhotoModel.h"
@interface YXPhotoCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong) YXPhotoModel * photoModel;
@property(nonatomic, copy) void (^selectHandle)(YXPhotoModel * model, UIButton * sender);

- (instancetype) initWithFrame:(CGRect)frame;
- (void)remakeFrameWithIndex:(NSInteger)nindex;
@end

//
//  PhotoCollectionViewCell.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 1/3/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) ALAsset *photoAsset;
@property (nonatomic, copy) void (^selectHandle)(UIImage *image);
@end

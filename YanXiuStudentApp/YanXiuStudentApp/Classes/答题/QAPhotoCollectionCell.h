//
//  QAPhotoCollectionCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAPhotoCollectionCell : UITableViewCell
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, assign) BOOL isCurrent;
@property (nonatomic, assign) BOOL bottomLineHidden;
@end

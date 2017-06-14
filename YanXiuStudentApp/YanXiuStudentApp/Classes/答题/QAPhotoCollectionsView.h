//
//  QAPhotoCollectionsView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAPhotoCollectionsView : UIView
@property (nonatomic, strong) NSArray<PHAssetCollection *> *collectionArray;
@property (nonatomic, strong) void(^collectionSelectBlock)(PHAssetCollection *collection);
@end

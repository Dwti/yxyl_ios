//
//  QAPhotoClipViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

@interface QAPhotoClipViewController : BaseViewController
@property (nonatomic, strong) UIImage *oriImage;
@property (nonatomic, strong) void(^clippedBlock)(UIImage *image);
@end

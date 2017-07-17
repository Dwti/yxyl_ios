//
//  HeadImageClipViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

@interface HeadImageClipViewController : BaseViewController
@property (nonatomic, strong) UIImage *oriImage;
@property (nonatomic, strong) void(^clippedBlock)(UIImage *image);
@end

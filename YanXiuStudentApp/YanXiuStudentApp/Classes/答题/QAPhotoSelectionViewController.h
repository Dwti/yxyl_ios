//
//  QAPhotoSelectionViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

@interface QAPhotoSelectionViewController : BaseViewController
@property (nonatomic, strong) void(^imageSelectionBlock)(UIImage *image);
@property (nonatomic, strong) void(^exitBlock)(void);
@end

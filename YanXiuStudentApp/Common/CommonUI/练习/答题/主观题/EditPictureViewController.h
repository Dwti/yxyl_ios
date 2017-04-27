//
//  EditPictureViewController.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/11/3.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "EditPictureView.h"

@interface EditPictureViewController : BaseViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) EditCompleteBlock editComplete;
@property (nonatomic, copy) CancelBlock cancel;

- (void)setEditComplete:(EditCompleteBlock)editComplete;
- (void)setCancel:(CancelBlock)cancel;

@end

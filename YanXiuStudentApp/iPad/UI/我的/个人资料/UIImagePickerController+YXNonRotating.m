//
//  UIImagePickerController+YXNonRotating.m
//  YanXiuStudentApp
//
//  Created by ChenJianjun on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "UIImagePickerController+YXNonRotating.h"

@implementation UIImagePickerController (YXNonRotating)

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

@end

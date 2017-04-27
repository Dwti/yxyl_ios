//
//  YXPhotoBrowser.h
//  ImagePickerDemo
//
//  Created by wd on 15/9/22.
//  Copyright © 2015年 wd. All rights reserved.
//

#import "MWPhotoBrowser.h"

@interface YXPhotoBrowser : MWPhotoBrowser
@property (nonatomic, copy) void (^deleteHandle)();
- (void)hiddenRightBarButtonItem:(BOOL)hidden;
@end

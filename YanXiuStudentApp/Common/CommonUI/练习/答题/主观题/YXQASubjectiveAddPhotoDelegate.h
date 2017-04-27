//
//  YXQASubjectiveAddPhotoDelegate.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXAlbumViewModel.h"

@protocol YXQASubjectiveAddPhotoDelegate <NSObject>
@optional
- (void)photoViewHeightChanged:(CGFloat)height;
- (void)addPhotoWithViewModel:(YXAlbumViewModel *)viewModel;
- (void)photoClickedWithModel:(YXAlbumViewModel *)viewModel index:(NSInteger)index canDelete:(BOOL)canDelete;
@end

//
//  YXQAAddPhotoCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/15.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQASubjectiveAddPhotoDelegate.h"

@interface YXQAAddPhotoCell_Pad : UITableViewCell

@property(nonatomic, weak)id<YXQASubjectiveAddPhotoDelegate>delegate;
@property(nonatomic, strong) YXAlbumViewModel * viewModel;
- (NSArray *)getPhotoArray;
- (void)reloadViewWithArray:(NSArray *)array addEnable:(BOOL)enable;

- (CGFloat)height;

@end

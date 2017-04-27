//
//  YXAddPhotoTableViewCell.h
//  YanXiuStudentApp
//
//  Created by wd on 15/9/28.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAlbumViewModel.h"
#import "YXQASubjectiveAddPhotoDelegate.h"


@interface YXAddPhotoTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) void(^photosChangedBlock)(NSArray *photos);
@property (nonatomic, weak) id<YXQASubjectiveAddPhotoDelegate>delegate;

- (void)reloadViewWithArray:(NSArray *)array addEnable:(BOOL)enable;
- (CGFloat)height;

@end

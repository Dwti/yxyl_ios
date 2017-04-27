//
//  PhotoListViewController.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/30/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

@interface PhotoListViewController : BaseViewController
@property (nonatomic, copy) void (^photoDidSelectBlock)(UIImage *image);
- (instancetype)initWithAlbumArray:(NSArray *)albumArray;
@end

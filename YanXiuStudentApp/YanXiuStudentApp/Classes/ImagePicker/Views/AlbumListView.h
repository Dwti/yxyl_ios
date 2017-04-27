//
//  AlbumListView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 12/30/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumListView : UIView
@property(nonatomic, copy) void (^albumSelectBlock)(NSInteger index);
- (instancetype)initWithAlbumList:(NSArray *)albumArray;
@end

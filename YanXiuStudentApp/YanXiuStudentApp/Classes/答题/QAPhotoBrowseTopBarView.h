//
//  QAPhotoBrowseTopBarView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAPhotoBrowseTopBarView : UIView
@property (nonatomic, strong) void(^exitBlock)();
@property (nonatomic, strong) void(^deleteBlock)();
@property (nonatomic, assign) BOOL canDelete;

- (void)updateWithCurrentIndex:(NSInteger)index total:(NSInteger)total;
@end

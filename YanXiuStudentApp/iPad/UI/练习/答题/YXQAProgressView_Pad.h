//
//  YXQAProgressView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQAProgressView_Pad : UIView
@property (nonatomic, copy) void(^preBlock)();
@property (nonatomic, copy) void(^nextBlock)();

- (void)updateWithIndex:(NSInteger)index total:(NSInteger)total;
@end

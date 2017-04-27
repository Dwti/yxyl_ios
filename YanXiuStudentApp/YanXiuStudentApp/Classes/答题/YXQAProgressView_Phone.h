//
//  YXQAProgressView_Phone.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/4/6.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQAProgressView_Phone : UIView
@property (nonatomic, copy) void(^preBlock)();
@property (nonatomic, copy) void(^nextBlock)();

- (void)updateWithIndex:(NSInteger)index total:(NSInteger)total;

@property (nonatomic, assign) BOOL preHidden;
@property (nonatomic, assign) BOOL nextHidden;
@end

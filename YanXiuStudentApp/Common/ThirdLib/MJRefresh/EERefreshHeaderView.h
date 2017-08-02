//
//  EERefreshHeaderView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/26.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefreshHeaderView.h"

@interface EERefreshHeaderView : UIView
- (instancetype)initWithMJHeaderView:(MJRefreshHeaderView *)headerView;
@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) BOOL animationFinished;
@property (nonatomic, strong) void(^endBubbleBlock) ();
- (void)updateWithOffset:(CGFloat)offset;
- (CGFloat)bottomHeight;
@end

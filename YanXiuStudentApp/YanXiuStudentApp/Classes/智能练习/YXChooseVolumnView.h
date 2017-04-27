//
//  YXVolumnChooseView.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/7/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXChooseVolumnView : UIView
@property (nonatomic, copy) void(^chooseBlock)(NSInteger index);

- (void)updateWithDatas:(NSArray *)dataArray selectedIndex:(NSInteger)index;
@end

//
//  YXQAConnectGroupView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAConnectItemView.h"

@interface YXQAConnectGroupView : UIView
@property (nonatomic, strong) YXQAConnectItemView *leftView;
@property (nonatomic, strong) YXQAConnectItemView *rightView;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)updateWithLeftContent:(NSString *)left rightContent:(NSString *)right;
+ (CGFloat)heightForLeftContent:(NSString *)left rightContent:(NSString *)right;
@end

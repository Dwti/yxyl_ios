//
//  QAConnectAnalysisGroupView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAConnectItemView.h"

@interface QAConnectAnalysisGroupView : UIView
@property (nonatomic, strong) QAConnectItemView *leftView;
@property (nonatomic, strong) QAConnectItemView *rightView;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)updateWithLeftContent:(NSString *)left rightContent:(NSString *)right;
+ (CGFloat)heightForLeftContent:(NSString *)left rightContent:(NSString *)right;
@end

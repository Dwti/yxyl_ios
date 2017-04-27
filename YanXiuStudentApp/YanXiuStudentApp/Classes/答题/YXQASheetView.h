//
//  YXQASheetView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/10.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQASheetViewDelegate.h"


@interface YXQASheetView : UIView
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, weak) id<YXQASheetViewDelegate> delegate;

//已经写完的题目数
@property (nonatomic, copy) NSString *wrote;

- (void)showInView:(UIView *)view;
- (BOOL)bAllHasAnswer;
@end

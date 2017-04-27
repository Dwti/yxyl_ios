//
//  YXQASheetView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQASheetViewDelegate.h"

@interface YXQASheetView_Pad : UIView
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, weak) id<YXQASheetViewDelegate> delegate;
@property (nonatomic, copy) NSString *wrote;
- (void)showInView:(UIView *)view;
- (BOOL)allHasAnswer;
@end

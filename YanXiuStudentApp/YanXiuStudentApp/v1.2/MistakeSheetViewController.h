//
//  MistakeSheetViewController.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/11/29.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^SelectedActionBlock)(QAQuestion *item);
typedef void(^BackActionBlock)(void);

@interface MistakeSheetViewController : BaseViewController
@property (nonatomic, strong) QAPaperModel *model;

- (void)setSelectedActionBlock:(SelectedActionBlock)block;
- (void)setBackActionBlock:(BackActionBlock)block;
@end

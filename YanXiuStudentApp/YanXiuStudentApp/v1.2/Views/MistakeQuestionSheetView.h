//
//  MistakeQuestionSheetView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MistakeRedoCatalogRequest.h"

@interface MistakeQuestionSheetView : UIView
@property (nonatomic, strong) QAPaperModel *model;
@property (nonatomic, strong) MistakeRedoCatalogRequestItem *item;
@property (nonatomic, strong) void(^selectBlock) (QAQuestion *question);
@property (nonatomic, strong) void(^cancelBlock) (void);
@end

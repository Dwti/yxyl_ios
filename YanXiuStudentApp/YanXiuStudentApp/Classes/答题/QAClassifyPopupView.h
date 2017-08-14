//
//  QAClassifyPopupView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/11.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAClassifyOptionInfo.h"

@interface QAClassifyPopupView : UIView
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSMutableArray<QAClassifyOptionInfo *> *optionInfoArray;
@property (nonatomic, strong) void(^foldBlock) ();
@property (nonatomic, strong) void(^deleteBlock) (QAClassifyOptionInfo *info);
@property (nonatomic, strong) void(^dragDownBlock) (CGFloat offset);
@end

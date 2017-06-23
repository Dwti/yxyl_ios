//
//  QAReportErrorOptionView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ErrorOptionChangeBlock)(void);

@interface QAReportErrorOption : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSUInteger tag;

@end

@interface QAReportErrorOptionView : UIView

@property (nonatomic, strong) NSMutableArray<QAReportErrorOption *> *optionSelectedArray;

- (void)setErrorOptionChangeBlock:(ErrorOptionChangeBlock)block;

@end

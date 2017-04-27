//
//  QAClassifyAnswersView.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 2016/10/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OptionsView.h"

@interface QAClassifyAnswersView : UIView

@property (nonatomic, assign) OptionsDataType type;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, weak) NSString *title;
@property (nonatomic, weak) DeleteBlock deleteBlock;
@property (nonatomic, assign) BOOL isAnalysis;

- (void)show;
- (void)hide;

@end

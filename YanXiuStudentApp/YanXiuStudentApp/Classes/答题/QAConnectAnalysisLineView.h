//
//  QAConnectAnalysisLineView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/18.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAConnectPosition : NSObject
@property (nonatomic, assign) CGFloat position;
@end

@interface QAConnectAnalysisLineView : UIView
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) NSMutableArray *positionArray;
@property (nonatomic, assign) BOOL showAnalysisAnswers;

@end

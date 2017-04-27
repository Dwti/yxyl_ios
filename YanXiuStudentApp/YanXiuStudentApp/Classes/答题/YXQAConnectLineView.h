//
//  YXQAConnectLineView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/10.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQAConnectPosition : NSObject
@property (nonatomic, assign) CGFloat position;
@end

@interface YXQAConnectLineView : UIView
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) NSMutableArray *positionArray;
@property (nonatomic, assign) BOOL showAnalysisAnswers;
@end

//
//  QAKnowledgePointView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAKnowledgePointView : UIView

@property (nonatomic, strong) NSArray *dataArray;

- (CGFloat)heightWithDataArray:(NSArray *)dataArray;

@end

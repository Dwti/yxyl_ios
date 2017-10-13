//
//  BCTopicAnswerStateFilterView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/16.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AnswerStateFilterCompletedBlock) (NSString *selectedTitle, NSInteger selectedRow);

@interface BCTopicAnswerStateFilterView : UIView
@property(nonatomic, assign) NSInteger selectedRow;

- (void)setAnswerStateFilterCompletedBlock:(AnswerStateFilterCompletedBlock)block;
@end

//
//  QAAnswerSheetCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const kQASelectedQuestionNotification; // 选中某个问题通知
extern NSString * const kQASelectedQuestionKey;// 选中某个问题通知的key

@interface QAAnswerSheetCell : UICollectionViewCell
@property (nonatomic, assign) BOOL hasWrote;
@property (nonatomic, strong) QAQuestion *item;
@end

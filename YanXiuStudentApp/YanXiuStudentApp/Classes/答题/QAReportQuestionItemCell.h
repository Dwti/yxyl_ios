//
//  QAReportQuestionItemCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/21.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChoseActionBlock)(QAQuestion *item);

@interface QAReportQuestionItemCell : UICollectionViewCell

@property (nonatomic, strong) QAQuestion *item;

- (void)setChoseActionBlock:(ChoseActionBlock)block;

@end

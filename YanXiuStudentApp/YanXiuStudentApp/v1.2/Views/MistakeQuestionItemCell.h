//
//  MistakeQuestionItemCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kQASelectedMiatakeQuestionNotification; // 选中某个问题通知
extern NSString * const kQASelectedMistakeQuestionKey;// 选中某个问题通知的key

@interface MistakeQuestionItemCell : UICollectionViewCell
@property (nonatomic, assign) BOOL hasWrote;
@property (nonatomic, strong) QAQuestion *item;
@end

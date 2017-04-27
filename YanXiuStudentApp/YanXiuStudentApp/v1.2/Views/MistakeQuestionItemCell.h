//
//  MistakeQuestionItemCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MistakeQuestionItemCell : UICollectionViewCell
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) void(^clickBlock)(MistakeQuestionItemCell *cell);
@end

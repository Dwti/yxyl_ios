//
//  QAKnowledgePointCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/27.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAKnowledgePointCell : UICollectionViewCell

@property (nonatomic, copy) NSString *knowledgePoint;

+ (CGSize)sizeForTitle:(NSString *)title;

@end

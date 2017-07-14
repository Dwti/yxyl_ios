//
//  QAClassifyAnswerGroupHeaderView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/14.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAClassifyAnswerGroupHeaderView : UICollectionReusableView
+ (CGSize)sizeForGroupName:(NSString *)name optionsCount:(NSInteger)count;
- (void)updateWithGroupName:(NSString *)name optionsCount:(NSInteger)count;
@end

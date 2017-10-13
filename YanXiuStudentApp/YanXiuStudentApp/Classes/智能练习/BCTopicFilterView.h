//
//  BCTopicFilterView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/15.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlphabeticallyBlock) (BOOL isFilterByAlphabetically, BOOL isPositiveSequence);
typedef void(^PopularityRankBlock) (BOOL isFilterByPopularityRank);
typedef void(^AnswerstateFilterBlock) (NSString *answerStateFilter);

@interface BCTopicFilterView : UIView

@property(nonatomic, copy) NSString *answerStateTitle;
- (void)setAlphabeticallyBlock:(AlphabeticallyBlock)block;
- (void)setPopularityRankBlock:(PopularityRankBlock)block;
- (void)setAnswerstateFilterBlock:(AnswerstateFilterBlock)block;

- (void)answerStateFilterAbort;
@end

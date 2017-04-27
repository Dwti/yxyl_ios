//
//  YXKnowledgePointView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/10/30.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXKnowledgePointView;
@protocol YXKnowledgePointViewDelegate <NSObject>

- (void)knowledgePointView:(YXKnowledgePointView *)pointView didSelectIndex:(NSInteger)index;

@end

@interface YXKnowledgePointView : UIView

@property (nonatomic, strong) NSArray *pointArray;
@property (nonatomic, weak) id<YXKnowledgePointViewDelegate> delegate;

+ (CGFloat)heightWithPoints:(NSArray *)pointArray viewWidth:(CGFloat)width;

@end

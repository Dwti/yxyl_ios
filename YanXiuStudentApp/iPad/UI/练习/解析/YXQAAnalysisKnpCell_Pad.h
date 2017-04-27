//
//  YXQAAnalysisKnpCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXKnowledgePointView.h"
#import "YXQAAnalysisItem.h"

@interface YXQAAnalysisKnpCell_Pad : UITableViewCell
@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) NSArray *knpArray;
@property (nonatomic, assign) BOOL knpClickable;
@property (nonatomic, weak) id<YXKnowledgePointViewDelegate> delegate;

+ (CGFloat)heightForPoints:(NSArray *)pointArray;
@end

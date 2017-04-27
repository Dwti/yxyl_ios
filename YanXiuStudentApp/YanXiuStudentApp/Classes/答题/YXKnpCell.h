//
//  YXKnpCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXKnowledgePointView.h"
#import "YXQAAnalysisItem.h"

@interface YXKnpCell : UITableViewCell
@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) NSArray *knpArray;
@property (nonatomic, assign) BOOL knpClickable;
@property (nonatomic, weak) id<YXKnowledgePointViewDelegate> delegate;

+ (CGFloat)heightForPoints:(NSArray *)pointArray;
@end

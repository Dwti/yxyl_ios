//
//  YXQAAnalysisCommentCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/28.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"

@interface YXQAAnalysisCommentCell_Pad : UITableViewCell
@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) BOOL marked;
- (void)updateUI;
+ (CGFloat)heightForMarkStatus:(BOOL)marked score:(CGFloat)score comment:(NSString *)comment;
@end

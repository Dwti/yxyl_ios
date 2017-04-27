//
//  YXCommentCell2.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/22.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"

@interface YXCommentCell2 : UITableViewCell
@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, assign) CGFloat score;
@property (nonatomic, assign) BOOL marked;
- (void)updateUI;
+ (CGFloat)heightForMarkStatus:(BOOL)marked score:(CGFloat)score comment:(NSString *)comment;
@end

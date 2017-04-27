//
//  CommenCell.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 2/8/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"

@interface CommentCell : UITableViewCell
@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, assign) BOOL isCorrect;
@property (nonatomic, assign) BOOL isMarked;
- (void)updateUI;
+ (CGFloat)heightForStatus;
@end

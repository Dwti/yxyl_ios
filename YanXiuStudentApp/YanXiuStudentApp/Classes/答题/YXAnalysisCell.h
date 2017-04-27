//
//  YXCommentCell2.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/21.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"
#import "YXHtmlCellHeightDelegate.h"

@interface YXAnalysisCell : UITableViewCell
@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string;
@end

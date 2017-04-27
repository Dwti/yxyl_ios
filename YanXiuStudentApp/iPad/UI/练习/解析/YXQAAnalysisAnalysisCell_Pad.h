//
//  YXQAAnalysisAnalysisCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXQAAnalysisItem.h"

@interface YXQAAnalysisAnalysisCell_Pad : UITableViewCell
@property (nonatomic, strong) YXQAAnalysisItem *item;
@property (nonatomic, strong) NSString *htmlString;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string;
@end

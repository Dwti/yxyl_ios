//
//  YXQAQuestionCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQAQuestionCell_Pad : UITableViewCell
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, assign) BOOL dashLineHidden;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string dashHidden:(BOOL)dashHidden;
@end

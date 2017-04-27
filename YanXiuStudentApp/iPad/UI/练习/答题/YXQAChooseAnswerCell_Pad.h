//
//  YXQAChooseAnswerCell_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/27.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXQAChooseAnswerCell_Pad : UITableViewCell

@property (nonatomic, assign) YXQAChooseMarkType markType;
@property (nonatomic, assign) BOOL bChoosed;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)updateWithItem:(QAQuestion *)item forIndex:(NSInteger)index;

+ (CGFloat)heightForString:(NSString *)string;

@end

//
//  YXQAChooseAnswerCell2.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/9.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXHtmlCellHeightDelegate.h"

typedef NS_ENUM(NSUInteger, ChooseCellMarkType) {
    EMarkCorrect,
    EMarkWrong,
    EMarkNone
};
@interface YXQAChooseAnswerCell2 : UITableViewCell
@property (nonatomic, assign) ChooseCellMarkType markType;
@property (nonatomic, assign) BOOL bChoosed;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

- (void)updateWithItem:(QAQuestion *)item forIndex:(NSInteger)index;

+ (CGFloat)heightForString:(NSString *)string;
@end

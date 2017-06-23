//
//  QAChooseOptionCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/5/23.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OptionCellMarkType) {
    OptionMarkType_Correct,
    OptionMarkType_Wrong,
    OptionMarkType_None
};

@interface QAChooseOptionCell : UITableViewCell
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) BOOL isAnalysis;
@property (nonatomic, assign) BOOL isMulti;
@property (nonatomic, assign) BOOL choosed;
@property (nonatomic, assign) OptionCellMarkType markType;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;

+ (CGFloat)heightForString:(NSString *)string;
- (void)updateWithOption:(NSString *)option forIndex:(NSInteger)index;
@end

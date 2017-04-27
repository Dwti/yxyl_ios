//
//  YXConnectContentCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/9.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXConnectContentCellDelegate <NSObject>
- (void)updateRedoStatus;
@end

@interface YXConnectContentCell : UITableViewCell
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, assign) BOOL showAnalysisAnswers;
@property (nonatomic, weak) id<YXHtmlCellHeightDelegate> delegate;
@property (nonatomic, weak) id<YXConnectContentCellDelegate> redoStatusDelegate;

+ (CGFloat)heightForItem:(QAQuestion *)item;
@end

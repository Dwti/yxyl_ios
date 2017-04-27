//
//  YXYesNoChooseView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 15/12/14.
//  Copyright © 2015年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YXAutoGoNextDelegate.h"

@protocol YXQAYesNoChooseCellDelegate <NSObject>
- (void)updateRedoStatus;
@end

@interface YXQAYesNoChooseCell : UITableViewCell

@property (nonatomic, strong) NSMutableArray *myAnswerArray;
@property (nonatomic, assign) id<YXAutoGoNextDelegate> delegate;
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, weak) id<YXQAYesNoChooseCellDelegate> redoStatusDelegate;

- (void)resetYesNoState;
- (void)updateWithMyAnswer:(NSArray *)myAnswerArray correctAnswer:(NSArray *)correctAnswerArray;

@end

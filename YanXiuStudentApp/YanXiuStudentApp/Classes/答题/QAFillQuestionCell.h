//
//  QAFillQuestionCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2016/12/8.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXQAQuestionCell2.h"

@protocol QAFillQuestionCellDelegate <NSObject>
- (void)updateRedoStatus;
@end

@interface QAFillQuestionCell : YXQAQuestionCell2
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, weak) id<QAFillQuestionCellDelegate> redoStatusDelegate;
@end

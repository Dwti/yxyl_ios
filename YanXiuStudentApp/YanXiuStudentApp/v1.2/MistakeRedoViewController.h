//
//  MistakeRedoViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QABaseViewController.h"

@interface MistakeRedoViewController : QABaseViewController<QAAnalysisEditNoteDelegate>
@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *subject;
@property (nonatomic, strong) void(^updateNumberBlock) (NSInteger num);
@property (nonatomic, strong) void(^updateNoteBlock) (NSArray *questions);
@property (nonatomic, strong) NSArray *qids;

@end

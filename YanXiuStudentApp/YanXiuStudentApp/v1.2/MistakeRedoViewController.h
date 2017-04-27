//
//  MistakeRedoViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/2/9.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "YXJieXiViewController.h"


@interface MistakeRedoViewController : YXJieXiViewController
@property (nonatomic, assign) NSInteger totalNumber;
@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *subject;
@property (nonatomic, strong) void(^updateNumberBlock) (NSInteger num);
@property (nonatomic, strong) void(^updateNoteBlock) (NSArray *questions);
@end

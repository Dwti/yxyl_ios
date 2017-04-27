//
//  EditNoteViewController.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 2/13/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "QAQuestion.h"

extern NSString *const MistakeNoteSaveNotification;

@interface EditNoteViewController : BaseViewController
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, copy) void (^saveButtonTapped) (void);
@end

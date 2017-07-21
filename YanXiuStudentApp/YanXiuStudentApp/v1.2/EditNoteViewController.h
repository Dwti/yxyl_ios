//
//  EditNoteViewController.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 2/13/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"
#import "QAQuestion.h"


@interface EditNoteViewController : BaseViewController
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, copy) void (^saveButtonTapped) (void);
@end

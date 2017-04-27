//
//  MistakeChapterViewController.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/27/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import "TreeBaseViewController.h"

@interface MistakeChapterViewController : TreeBaseViewController
@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *subject;
@property (nonatomic, copy) NSString *subjectID;
@property (nonatomic, copy) NSString *editionID;
@end

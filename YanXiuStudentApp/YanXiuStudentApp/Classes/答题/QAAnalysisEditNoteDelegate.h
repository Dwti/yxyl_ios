//
//  QAAnalysisEditNoteDelegate.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 2/13/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditNoteViewController.h"
#import "QAQuestion.h"

@protocol QAAnalysisEditNoteDelegate <NSObject>
- (void)editNoteButtonTapped:(QAQuestion *)item;
@end

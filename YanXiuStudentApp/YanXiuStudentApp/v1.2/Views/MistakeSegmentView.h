//
//  MistakeSegmentView.h
//  YanXiuStudentApp
//
//  Created by Yu Fan on 3/27/17.
//  Copyright © 2017 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MistakeSegmentView : UIView
@property (nonatomic, copy) void (^buttonTappedBlock) (UIButton *sender);
- (instancetype)initWithSubject:(GetSubjectMistakeRequestItem_subjectMistake_data *)subject;
- (BOOL)isShowKnpButton;
- (BOOL)isShowChapterButton;
@end

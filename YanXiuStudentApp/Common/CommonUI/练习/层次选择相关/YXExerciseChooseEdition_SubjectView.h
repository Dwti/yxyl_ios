//
//  YXExerciseChooseEdition_SubjectView.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/3/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YXExerciseChooseEdition_SubjectView;
static const CGFloat kYXExerciseChooseEdition_SubjectView_Width = 145;
static const CGFloat kYXExerciseChooseEdition_SubjectView_Height = 125;

@protocol YXExerciseChooseEdition_SubjectViewDelegate <NSObject>
- (void)subjectViewSubjectTapped:(YXExerciseChooseEdition_SubjectView *)view;
- (void)subjectViewChooseEditionTapped:(YXExerciseChooseEdition_SubjectView *)view;
@end


@interface YXExerciseChooseEdition_SubjectView : UIView
@property (nonatomic, weak) id<YXExerciseChooseEdition_SubjectViewDelegate> delegate;
- (void)updateWithData:(GetSubjectRequestItem_subject *)subject;
@end

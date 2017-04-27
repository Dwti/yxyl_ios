//
//  YXExerciseChooseEdition_ContainerView.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 1/27/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YXExerciseChooseEdition_ContainerViewDelegate <NSObject>
- (void)chooseEditionForSubject:(YXNodeElement *)subject;
- (void)gotoChooseChapterKnpForSubject:(YXNodeElement *)subject;

- (void)edition:(YXNodeElement *)edition ChoosedForSubject:(YXNodeElement *)subject;
@end

@interface YXExerciseChooseEdition_ContainerView : UIView
@property (nonatomic, weak) id<YXExerciseChooseEdition_ContainerViewDelegate> delegate;

@property (nonatomic, assign) NSInteger columnCount;
@property (nonatomic, assign) CGFloat hGap;
@property (nonatomic, assign) CGFloat vGap;

- (void)reloadWithSubjects:(NSArray *)subjects;
- (void)showEditionsToChooseForSubject:(YXNodeElement *)subject;
@end

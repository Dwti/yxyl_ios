//
//  YXChooseEditionView.h
//  YanXiuStudentApp
//
//  Created by Lei Cai on 12/4/15.
//  Copyright © 2015 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXExerciseChooseEdition_SubjectEditionListedView : UIView
@property (nonatomic, copy) void (^choosenBlock)(GetEditionRequestItem_edition *edition);

@property (nonatomic, strong) GetSubjectRequestItem_subject *subject;
@property (nonatomic, strong) GetEditionRequestItem *editionItem;

- (void)doHide;

#pragma mark - 统一大业
@property (nonatomic, assign) CGFloat gapToCalculateHeight;    // 距离底边空隙长度
@end

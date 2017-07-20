//
//  MistakeSubjectCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MistakeSubjectCell : UITableViewCell
@property (nonatomic, strong) GetSubjectMistakeRequestItem_subjectMistake *data;
@property (nonatomic, assign) BOOL shouldShowBottomLine;
@end

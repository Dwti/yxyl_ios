//
//  TextbookVersionView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/25.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChooseVersionActionBlock)(GetSubjectRequestItem_subject *subject,BOOL hasChoosedEdition);

@interface TextbookVersionView : UIView
@property (nonatomic, strong) GetSubjectRequestItem *item;
- (void)setChooseVersionActionBlock:(ChooseVersionActionBlock)block;

@end

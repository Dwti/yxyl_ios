//
//  TextbookVersionCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/25.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetSubjectRequest.h"

@interface TextbookVersionCell : UICollectionViewCell
@property (nonatomic, strong) GetSubjectRequestItem_subject *subject;
@property (nonatomic, assign) BOOL hasChoosedEdition;
@end

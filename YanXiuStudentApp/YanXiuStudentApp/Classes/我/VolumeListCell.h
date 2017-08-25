//
//  VolumeListCell.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/8/28.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GetSubjectRequestItem_subject;

@interface VolumeListCell : UITableViewCell
@property (nonatomic, strong) GetSubjectRequestItem_subject *subject;
@property (nonatomic, assign) BOOL shouldShowShadow;

@end

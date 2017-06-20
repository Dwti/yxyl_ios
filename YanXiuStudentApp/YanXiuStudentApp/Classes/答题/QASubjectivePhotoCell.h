//
//  QASubjectivePhotoCell.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QASubjectivePhotoCell : UITableViewCell
@property (nonatomic, strong) void(^numberChangedBlock)(NSInteger from,NSInteger to);
- (void)updateWithPhotos:(NSMutableArray *)photos editable:(BOOL)isEditable;
@end

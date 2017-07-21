//
//  QANoteImagesView.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/22.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QANoteImagesView : UIView
- (void)updateWithPhotos:(NSMutableArray<QAImageAnswer *> *)photos editable:(BOOL)isEditable;
@end

//
//  QAImageUploadProgressView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/6/19.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QAImageUploadProgressView : UIView
- (void)updateWithUploadedCount:(NSInteger)uploadedCount totalCount:(NSInteger)totalCount;
@end

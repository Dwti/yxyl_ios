//
//  ScaleView.h
//  test
//
//  Created by 贾培军 on 2016/11/1.
//  Copyright © 2016年 DJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EditCompleteBlock) (UIImage *image);
typedef void (^CancelBlock) (void);

@interface EditPictureView : UIView

@property (nonatomic, copy) EditCompleteBlock editComplete;
@property (nonatomic, copy) CancelBlock cancel;

- (instancetype)initWithFrame:(CGRect)frame image:(UIImage *)image;
- (void)setEditComplete:(EditCompleteBlock)editComplete;
- (void)firstLoad;
@end

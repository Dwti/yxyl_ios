//
//  YXQAMaterialView_Pad.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/1/29.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "YXSlideView.h"
#import "YXAutoGoNextDelegate.h"

@interface YXQAMaterialView_Pad : YXSlideViewItemViewBase
@property (nonatomic, assign) NSInteger nextLevelStartIndex;

@property (nonatomic, strong) QAQuestion *data;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) id<YXAutoGoNextDelegate> delegate;

@property (nonatomic, strong) YXSlideView *slideView;

@end

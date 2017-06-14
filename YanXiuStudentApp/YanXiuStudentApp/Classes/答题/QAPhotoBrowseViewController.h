//
//  QAPhotoBrowseViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/20.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "BaseViewController.h"

@interface QAPhotoBrowseViewController : BaseViewController
@property (nonatomic, strong) NSMutableArray<QAImageAnswer *> *itemArray;
@property (nonatomic, assign) NSInteger oriIndex;
@property (nonatomic, assign) BOOL canDelete;
@property (nonatomic, strong) void(^deleteBlock)();
@end

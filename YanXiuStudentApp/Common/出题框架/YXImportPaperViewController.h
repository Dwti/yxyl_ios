//
//  YXImportPaperViewController.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YXImportPaperViewController : UIViewController
@property (nonatomic, strong) NSArray *papers;
@property (nonatomic, strong) void(^completeBlock)();
@end

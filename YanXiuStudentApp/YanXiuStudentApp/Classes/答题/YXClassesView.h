//
//  YXClassesView.h
//  YanXiuStudentApp
//
//  Created by 贾培军 on 16/8/16.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  这个是归类题上面的分类
 */

typedef void (^TouchClasses)(NSInteger index);

@interface YXClassesView : UIView
@property (nonatomic, strong) QAQuestion *item;
@property (nonatomic, strong) NSMutableArray *groupArray;
@property (nonatomic, copy) TouchClasses touchClasses;

+ (CGFloat)heightForItem:(QAQuestion *)item;
+ (NSString *)titleWithItem:(QANumberGroupAnswer *)item;

- (void)reloadData;

@end

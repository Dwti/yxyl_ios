//
//  QAClozeQuestionCellDelegate.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/6.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QAClozeQuestionCellDelegate <NSObject>
- (void)didSelectItemAtIndex:(NSInteger)index;
- (void)layoutRefreshed;
- (void)stemClicked;
@end

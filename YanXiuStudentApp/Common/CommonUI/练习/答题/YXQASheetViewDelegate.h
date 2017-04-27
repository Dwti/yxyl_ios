//
//  YXQASheetViewDelegate.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YXQASheetViewDelegate <NSObject>

- (void)sheetViewDidSelectItem:(QAQuestion *)item;
- (void)sheetViewDidSubmit;
- (void)sheetViewDidCancel;

@end

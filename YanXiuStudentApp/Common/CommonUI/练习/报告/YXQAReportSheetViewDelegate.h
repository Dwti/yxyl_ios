//
//  YXQAReportSheetViewDelegate.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/2/1.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol YXQAReportSheetViewDelegate <NSObject>
- (void)sheetView:(UIView *)sheetView didSelectItemAtIndex:(NSInteger)index;
@end

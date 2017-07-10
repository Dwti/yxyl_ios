//
//  QAConnectOptionsView.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/12.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^SelectedOptionCellActionBlock)(NSString *optionString);


@interface QAConnectOptionsView : UIView
@property (nonatomic, strong) NSMutableArray *optionsArray;

- (void)setSelectedOptionCellActionBlock:(SelectedOptionCellActionBlock)block;
- (void)reloadData;

@end

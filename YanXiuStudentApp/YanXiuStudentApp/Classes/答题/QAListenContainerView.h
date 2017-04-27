//
//  QAListenContainerView.h
//  YanXiuStudentApp
//
//  Created by FanYu on 10/25/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAListenComplexCell.h"

@interface QAListenContainerView : UIView

@property (nonatomic, weak) QAListenComplexCell *cell;

- (instancetype)initWithData:(QAQuestion *)data; //designated init

@end

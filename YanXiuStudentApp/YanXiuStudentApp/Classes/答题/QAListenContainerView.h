//
//  QAListenContainerView.h
//  YanXiuStudentApp
//
//  Created by FanYu on 10/25/16.
//  Copyright © 2016 yanxiu.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QAListenStemCell.h"

@interface QAListenContainerView : UIView<QAComplexTopContainerViewDelegate>

@property (nonatomic, weak) QAListenStemCell *cell;


- (instancetype)initWithData:(QAQuestion *)data; //designated init

@end

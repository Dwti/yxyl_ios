//
//  QAConnectOptionInfo.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/7/17.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QAConnectOptionInfo;

@interface QAConnectTwinOptionInfo : NSObject
@property (nonatomic, strong) QAConnectOptionInfo  *leftOptionInfo;
@property (nonatomic, strong) QAConnectOptionInfo  *rightOptionInfo;
@property (nonatomic, assign) CGFloat height;

@end

@interface QAConnectOptionInfo : NSObject
@property (nonatomic, strong) NSString *option;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isCorrect; // used for analysis
@end

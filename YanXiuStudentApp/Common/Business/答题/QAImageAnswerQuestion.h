//
//  QAImageAnswerQuestion.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestion.h"

@interface QAImageAnswer : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) id data;
@end

static const NSInteger kFullMarkScore = 5;

@interface QAImageAnswerQuestion : QAQuestion

@end

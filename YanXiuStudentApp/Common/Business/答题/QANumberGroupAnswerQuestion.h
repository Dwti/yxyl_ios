//
//  QANumberGroupAnswerQuestion.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/12.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import "QAQuestion.h"

@interface QANumberGroupAnswer : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSMutableArray *answers;
@end

@interface QANumberGroupAnswerQuestion : QAQuestion

@end

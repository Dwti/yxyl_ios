//
//  QAQuestionTemplateMappingTable.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/9/14.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QAQuestionTemplateMappingTable : NSObject
+ (YXQATemplateType)templateTypeForTemplate:(NSString *)templateString;
@end

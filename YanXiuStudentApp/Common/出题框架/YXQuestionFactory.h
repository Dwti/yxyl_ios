//
//  YXQuestionFactory.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 16/8/2.
//  Copyright © 2016年 yanxiu.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YXIntelligenceQuestion.h"

@interface YXQuestionFactory : NSObject
+ (YXIntelligenceQuestion_PaperTest *)questionWithType:(YXQAItemType)type template:(YXQATemplateType)qTemplate;
@end

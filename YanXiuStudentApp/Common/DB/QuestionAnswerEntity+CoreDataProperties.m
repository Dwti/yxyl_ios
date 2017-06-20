//
//  QuestionAnswerEntity+CoreDataProperties.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/21.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QuestionAnswerEntity+CoreDataProperties.h"

@implementation QuestionAnswerEntity (CoreDataProperties)

+ (NSFetchRequest<QuestionAnswerEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"QuestionAnswerEntity"];
}

@dynamic questionKey;
@dynamic questionAnswer;

@end

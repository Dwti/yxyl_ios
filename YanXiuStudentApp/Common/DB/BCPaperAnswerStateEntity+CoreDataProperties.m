//
//  BCPaperAnswerStateEntity+CoreDataProperties.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//
//

#import "BCPaperAnswerStateEntity+CoreDataProperties.h"

@implementation BCPaperAnswerStateEntity (CoreDataProperties)

+ (NSFetchRequest<BCPaperAnswerStateEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"BCPaperAnswerStateEntity"];
}

@dynamic uid;
@dynamic paperID;
@dynamic answerState;

@end

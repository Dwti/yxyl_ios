//
//  PaperAnswerDurationEntity+CoreDataProperties.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PaperAnswerDurationEntity+CoreDataProperties.h"

@implementation PaperAnswerDurationEntity (CoreDataProperties)

+ (NSFetchRequest<PaperAnswerDurationEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PaperAnswerDurationEntity"];
}

@dynamic uid;
@dynamic paperID;
@dynamic duration;

@end

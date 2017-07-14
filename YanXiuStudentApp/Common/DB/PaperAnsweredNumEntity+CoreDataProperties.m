//
//  PaperAnsweredNumEntity+CoreDataProperties.m
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PaperAnsweredNumEntity+CoreDataProperties.h"

@implementation PaperAnsweredNumEntity (CoreDataProperties)

+ (NSFetchRequest<PaperAnsweredNumEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PaperAnsweredNumEntity"];
}

@dynamic uid;
@dynamic paperID;
@dynamic answeredNum;

@end

//
//  PaperHasShowVideoEntity+CoreDataProperties.m
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//
//

#import "PaperHasShowVideoEntity+CoreDataProperties.h"

@implementation PaperHasShowVideoEntity (CoreDataProperties)

+ (NSFetchRequest<PaperHasShowVideoEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"PaperHasShowVideoEntity"];
}

@dynamic paperID;
@dynamic uid;
@dynamic hasShowVideo;

@end

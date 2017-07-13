//
//  PaperAnsweredNumEntity+CoreDataProperties.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/13.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PaperAnsweredNumEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PaperAnsweredNumEntity (CoreDataProperties)

+ (NSFetchRequest<PaperAnsweredNumEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSString *paperID;
@property (nullable, nonatomic, copy) NSNumber *answeredNum;

@end

NS_ASSUME_NONNULL_END

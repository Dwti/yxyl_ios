//
//  QuestionAnswerEntity+CoreDataProperties.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/6/21.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "QuestionAnswerEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface QuestionAnswerEntity (CoreDataProperties)

+ (NSFetchRequest<QuestionAnswerEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *questionKey;
@property (nullable, nonatomic, copy) NSString *questionAnswer;

@end

NS_ASSUME_NONNULL_END

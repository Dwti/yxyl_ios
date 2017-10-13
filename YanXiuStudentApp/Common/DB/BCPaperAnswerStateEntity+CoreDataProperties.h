//
//  BCPaperAnswerStateEntity+CoreDataProperties.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//
//

#import "BCPaperAnswerStateEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface BCPaperAnswerStateEntity (CoreDataProperties)

+ (NSFetchRequest<BCPaperAnswerStateEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSString *paperID;
@property (nullable, nonatomic, copy) NSString *answerState;

@end

NS_ASSUME_NONNULL_END

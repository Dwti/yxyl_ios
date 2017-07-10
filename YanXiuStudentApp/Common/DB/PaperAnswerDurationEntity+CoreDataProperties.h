//
//  PaperAnswerDurationEntity+CoreDataProperties.h
//  YanXiuStudentApp
//
//  Created by niuzhaowang on 2017/7/10.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//

#import "PaperAnswerDurationEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PaperAnswerDurationEntity (CoreDataProperties)

+ (NSFetchRequest<PaperAnswerDurationEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSString *paperID;
@property (nullable, nonatomic, copy) NSNumber *duration;

@end

NS_ASSUME_NONNULL_END

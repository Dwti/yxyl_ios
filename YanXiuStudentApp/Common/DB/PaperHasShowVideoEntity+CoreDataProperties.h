//
//  PaperHasShowVideoEntity+CoreDataProperties.h
//  YanXiuStudentApp
//
//  Created by ZLL on 2017/10/24.
//  Copyright © 2017年 yanxiu.com. All rights reserved.
//
//

#import "PaperHasShowVideoEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface PaperHasShowVideoEntity (CoreDataProperties)

+ (NSFetchRequest<PaperHasShowVideoEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *paperID;
@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSString *hasShowVideo;

@end

NS_ASSUME_NONNULL_END

//
//  SectionEntity+CoreDataProperties.h
//  testPods
//
//  Created by Lei Cai on 10/29/15.
//  Copyright © 2015 yanxiu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SectionEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface SectionEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *sectionID;
@property (nullable, nonatomic, retain) NSString *sectionName;
@property (nullable, nonatomic, retain) NSSet<ExerciseEntity *> *exercise;

@end

@interface SectionEntity (CoreDataGeneratedAccessors)

- (void)addExerciseObject:(ExerciseEntity *)value;
- (void)removeExerciseObject:(ExerciseEntity *)value;
- (void)addExercise:(NSSet<ExerciseEntity *> *)values;
- (void)removeExercise:(NSSet<ExerciseEntity *> *)values;

@end

NS_ASSUME_NONNULL_END

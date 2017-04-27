//
//  ChapterEntity+CoreDataProperties.h
//  testPods
//
//  Created by Lei Cai on 10/29/15.
//  Copyright © 2015 yanxiu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChapterEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChapterEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chapterID;
@property (nullable, nonatomic, retain) NSString *chapterName;
@property (nullable, nonatomic, retain) NSSet<ExerciseEntity *> *exercise;

@end

@interface ChapterEntity (CoreDataGeneratedAccessors)

- (void)addExerciseObject:(ExerciseEntity *)value;
- (void)removeExerciseObject:(ExerciseEntity *)value;
- (void)addExercise:(NSSet<ExerciseEntity *> *)values;
- (void)removeExercise:(NSSet<ExerciseEntity *> *)values;

@end

NS_ASSUME_NONNULL_END

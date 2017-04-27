//
//  ExerciseEntity+CoreDataProperties.h
//  testPods
//
//  Created by Lei Cai on 10/29/15.
//  Copyright © 2015 yanxiu. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ExerciseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chapterID;
@property (nullable, nonatomic, retain) NSString *exerciseID;
@property (nullable, nonatomic, retain) NSString *sectionID;
@property (nullable, nonatomic, retain) NSString *unitID;
@property (nullable, nonatomic, retain) NSString *volumeID;
@property (nullable, nonatomic, retain) ChapterEntity *chapter;
@property (nullable, nonatomic, retain) SectionEntity *section;
@property (nullable, nonatomic, retain) UnitEntity *unit;
@property (nullable, nonatomic, retain) VolumeEntity *volume;

@end

NS_ASSUME_NONNULL_END

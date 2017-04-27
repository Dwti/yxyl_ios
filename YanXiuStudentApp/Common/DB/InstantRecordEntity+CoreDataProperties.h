//
//  InstantRecordEntity+CoreDataProperties.h
//  
//
//  Created by 贾培军 on 16/6/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "InstantRecordEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface InstantRecordEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;

@end

NS_ASSUME_NONNULL_END

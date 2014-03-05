// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DRRun.h instead.

#import <CoreData/CoreData.h>
#import "SSManagedObject.h"

extern const struct DRRunAttributes {
	__unsafe_unretained NSString *averageDrift;
	__unsafe_unretained NSString *created;
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *locations;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *uniqueID;
} DRRunAttributes;

extern const struct DRRunRelationships {
	__unsafe_unretained NSString *path;
} DRRunRelationships;

extern const struct DRRunFetchedProperties {
} DRRunFetchedProperties;

@class DRPath;





@class NSObject;



@interface DRRunID : NSManagedObjectID {}
@end

@interface _DRRun : SSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DRRunID*)objectID;





@property (nonatomic, strong) NSNumber* averageDrift;



@property float averageDriftValue;
- (float)averageDriftValue;
- (void)setAverageDriftValue:(float)value_;

//- (BOOL)validateAverageDrift:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* created;



//- (BOOL)validateCreated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* distance;



@property float distanceValue;
- (float)distanceValue;
- (void)setDistanceValue:(float)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id locations;



//- (BOOL)validateLocations:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* uniqueID;



//- (BOOL)validateUniqueID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) DRPath *path;

//- (BOOL)validatePath:(id*)value_ error:(NSError**)error_;





@end

@interface _DRRun (CoreDataGeneratedAccessors)

@end

@interface _DRRun (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAverageDrift;
- (void)setPrimitiveAverageDrift:(NSNumber*)value;

- (float)primitiveAverageDriftValue;
- (void)setPrimitiveAverageDriftValue:(float)value_;




- (NSDate*)primitiveCreated;
- (void)setPrimitiveCreated:(NSDate*)value;




- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (float)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(float)value_;




- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (id)primitiveLocations;
- (void)setPrimitiveLocations:(id)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSString*)primitiveUniqueID;
- (void)setPrimitiveUniqueID:(NSString*)value;





- (DRPath*)primitivePath;
- (void)setPrimitivePath:(DRPath*)value;


@end

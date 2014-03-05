// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DRPath.h instead.

#import <CoreData/CoreData.h>
#import "SSManagedObject.h"

extern const struct DRPathAttributes {
	__unsafe_unretained NSString *created;
	__unsafe_unretained NSString *distance;
	__unsafe_unretained NSString *points;
	__unsafe_unretained NSString *uniqueID;
} DRPathAttributes;

extern const struct DRPathRelationships {
	__unsafe_unretained NSString *runs;
} DRPathRelationships;

extern const struct DRPathFetchedProperties {
} DRPathFetchedProperties;

@class DRRun;



@class NSObject;


@interface DRPathID : NSManagedObjectID {}
@end

@interface _DRPath : SSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DRPathID*)objectID;





@property (nonatomic, strong) NSDate* created;



//- (BOOL)validateCreated:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* distance;



@property float distanceValue;
- (float)distanceValue;
- (void)setDistanceValue:(float)value_;

//- (BOOL)validateDistance:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id points;



//- (BOOL)validatePoints:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* uniqueID;



//- (BOOL)validateUniqueID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) DRRun *runs;

//- (BOOL)validateRuns:(id*)value_ error:(NSError**)error_;





@end

@interface _DRPath (CoreDataGeneratedAccessors)

@end

@interface _DRPath (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreated;
- (void)setPrimitiveCreated:(NSDate*)value;




- (NSNumber*)primitiveDistance;
- (void)setPrimitiveDistance:(NSNumber*)value;

- (float)primitiveDistanceValue;
- (void)setPrimitiveDistanceValue:(float)value_;




- (id)primitivePoints;
- (void)setPrimitivePoints:(id)value;




- (NSString*)primitiveUniqueID;
- (void)setPrimitiveUniqueID:(NSString*)value;





- (DRRun*)primitiveRuns;
- (void)setPrimitiveRuns:(DRRun*)value;


@end

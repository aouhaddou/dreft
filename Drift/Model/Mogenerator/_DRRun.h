// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DRRun.h instead.

#import <CoreData/CoreData.h>


extern const struct DRRunAttributes {
	__unsafe_unretained NSString *averageDrift;
	__unsafe_unretained NSString *coordinates;
	__unsafe_unretained NSString *createDate;
	__unsafe_unretained NSString *endDate;
	__unsafe_unretained NSString *startDate;
	__unsafe_unretained NSString *steps;
	__unsafe_unretained NSString *time;
	__unsafe_unretained NSString *totalDistance;
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

@interface _DRRun : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DRRunID*)objectID;





@property (nonatomic, strong) NSNumber* averageDrift;



@property float averageDriftValue;
- (float)averageDriftValue;
- (void)setAverageDriftValue:(float)value_;

//- (BOOL)validateAverageDrift:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) id coordinates;



//- (BOOL)validateCoordinates:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* createDate;



//- (BOOL)validateCreateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* endDate;



//- (BOOL)validateEndDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* startDate;



//- (BOOL)validateStartDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* steps;



@property int32_t stepsValue;
- (int32_t)stepsValue;
- (void)setStepsValue:(int32_t)value_;

//- (BOOL)validateSteps:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* time;



@property float timeValue;
- (float)timeValue;
- (void)setTimeValue:(float)value_;

//- (BOOL)validateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* totalDistance;



@property float totalDistanceValue;
- (float)totalDistanceValue;
- (void)setTotalDistanceValue:(float)value_;

//- (BOOL)validateTotalDistance:(id*)value_ error:(NSError**)error_;





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




- (id)primitiveCoordinates;
- (void)setPrimitiveCoordinates:(id)value;




- (NSDate*)primitiveCreateDate;
- (void)setPrimitiveCreateDate:(NSDate*)value;




- (NSDate*)primitiveEndDate;
- (void)setPrimitiveEndDate:(NSDate*)value;




- (NSDate*)primitiveStartDate;
- (void)setPrimitiveStartDate:(NSDate*)value;




- (NSNumber*)primitiveSteps;
- (void)setPrimitiveSteps:(NSNumber*)value;

- (int32_t)primitiveStepsValue;
- (void)setPrimitiveStepsValue:(int32_t)value_;




- (NSNumber*)primitiveTime;
- (void)setPrimitiveTime:(NSNumber*)value;

- (float)primitiveTimeValue;
- (void)setPrimitiveTimeValue:(float)value_;




- (NSNumber*)primitiveTotalDistance;
- (void)setPrimitiveTotalDistance:(NSNumber*)value;

- (float)primitiveTotalDistanceValue;
- (void)setPrimitiveTotalDistanceValue:(float)value_;





- (DRPath*)primitivePath;
- (void)setPrimitivePath:(DRPath*)value;


@end

// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DRRun.m instead.

#import "_DRRun.h"

const struct DRRunAttributes DRRunAttributes = {
	.averageDrift = @"averageDrift",
	.coordinates = @"coordinates",
	.date = @"date",
	.steps = @"steps",
	.time = @"time",
	.totalDistance = @"totalDistance",
};

const struct DRRunRelationships DRRunRelationships = {
	.path = @"path",
};

const struct DRRunFetchedProperties DRRunFetchedProperties = {
};

@implementation DRRunID
@end

@implementation _DRRun

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DRRun" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DRRun";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DRRun" inManagedObjectContext:moc_];
}

- (DRRunID*)objectID {
	return (DRRunID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"averageDriftValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"averageDrift"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stepsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"steps"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"timeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"time"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"totalDistanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"totalDistance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic averageDrift;



- (float)averageDriftValue {
	NSNumber *result = [self averageDrift];
	return [result floatValue];
}

- (void)setAverageDriftValue:(float)value_ {
	[self setAverageDrift:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveAverageDriftValue {
	NSNumber *result = [self primitiveAverageDrift];
	return [result floatValue];
}

- (void)setPrimitiveAverageDriftValue:(float)value_ {
	[self setPrimitiveAverageDrift:[NSNumber numberWithFloat:value_]];
}





@dynamic coordinates;






@dynamic date;






@dynamic steps;



- (int64_t)stepsValue {
	NSNumber *result = [self steps];
	return [result longLongValue];
}

- (void)setStepsValue:(int64_t)value_ {
	[self setSteps:[NSNumber numberWithLongLong:value_]];
}

- (int64_t)primitiveStepsValue {
	NSNumber *result = [self primitiveSteps];
	return [result longLongValue];
}

- (void)setPrimitiveStepsValue:(int64_t)value_ {
	[self setPrimitiveSteps:[NSNumber numberWithLongLong:value_]];
}





@dynamic time;



- (float)timeValue {
	NSNumber *result = [self time];
	return [result floatValue];
}

- (void)setTimeValue:(float)value_ {
	[self setTime:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveTimeValue {
	NSNumber *result = [self primitiveTime];
	return [result floatValue];
}

- (void)setPrimitiveTimeValue:(float)value_ {
	[self setPrimitiveTime:[NSNumber numberWithFloat:value_]];
}





@dynamic totalDistance;



- (float)totalDistanceValue {
	NSNumber *result = [self totalDistance];
	return [result floatValue];
}

- (void)setTotalDistanceValue:(float)value_ {
	[self setTotalDistance:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveTotalDistanceValue {
	NSNumber *result = [self primitiveTotalDistance];
	return [result floatValue];
}

- (void)setPrimitiveTotalDistanceValue:(float)value_ {
	[self setPrimitiveTotalDistance:[NSNumber numberWithFloat:value_]];
}





@dynamic path;

	






@end

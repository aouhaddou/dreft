// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DRRun.m instead.

#import "_DRRun.h"

const struct DRRunAttributes DRRunAttributes = {
	.averageDrift = @"averageDrift",
	.created = @"created",
	.distance = @"distance",
	.endDate = @"endDate",
	.locations = @"locations",
	.startDate = @"startDate",
	.uniqueID = @"uniqueID",
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
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
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





@dynamic created;






@dynamic distance;



- (float)distanceValue {
	NSNumber *result = [self distance];
	return [result floatValue];
}

- (void)setDistanceValue:(float)value_ {
	[self setDistance:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDistanceValue {
	NSNumber *result = [self primitiveDistance];
	return [result floatValue];
}

- (void)setPrimitiveDistanceValue:(float)value_ {
	[self setPrimitiveDistance:[NSNumber numberWithFloat:value_]];
}





@dynamic endDate;






@dynamic locations;






@dynamic startDate;






@dynamic uniqueID;






@dynamic path;

	






@end

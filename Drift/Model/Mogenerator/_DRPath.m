// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DRPath.m instead.

#import "_DRPath.h"

const struct DRPathAttributes DRPathAttributes = {
	.createDate = @"createDate",
	.distance = @"distance",
	.points = @"points",
};

const struct DRPathRelationships DRPathRelationships = {
	.runs = @"runs",
};

const struct DRPathFetchedProperties DRPathFetchedProperties = {
};

@implementation DRPathID
@end

@implementation _DRPath

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DRPath" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DRPath";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DRPath" inManagedObjectContext:moc_];
}

- (DRPathID*)objectID {
	return (DRPathID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"distanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"distance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic createDate;






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





@dynamic points;






@dynamic runs;

	






@end

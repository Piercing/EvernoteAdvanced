// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCLocation.m instead.

#import "_MGCLocation.h"

const struct MGCLocationAttributes MGCLocationAttributes = {
	.address = @"address",
	.latitud = @"latitud",
	.longitude = @"longitude",
};

const struct MGCLocationRelationships MGCLocationRelationships = {
	.mapSnapshot = @"mapSnapshot",
	.notes = @"notes",
};

@implementation MGCLocationID
@end

@implementation _MGCLocation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Location";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Location" inManagedObjectContext:moc_];
}

- (MGCLocationID*)objectID {
	return (MGCLocationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"latitudValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitud"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic address;

@dynamic latitud;

- (double)latitudValue {
	NSNumber *result = [self latitud];
	return [result doubleValue];
}

- (void)setLatitudValue:(double)value_ {
	[self setLatitud:@(value_)];
}

- (double)primitiveLatitudValue {
	NSNumber *result = [self primitiveLatitud];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudValue:(double)value_ {
	[self setPrimitiveLatitud:@(value_)];
}

@dynamic longitude;

- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:@(value_)];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:@(value_)];
}

@dynamic mapSnapshot;

@dynamic notes;

- (NSMutableSet*)notesSet {
	[self willAccessValueForKey:@"notes"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"notes"];

	[self didAccessValueForKey:@"notes"];
	return result;
}

@end


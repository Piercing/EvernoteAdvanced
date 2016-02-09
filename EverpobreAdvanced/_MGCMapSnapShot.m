// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCMapSnapShot.m instead.

#import "_MGCMapSnapShot.h"

const struct MGCMapSnapShotAttributes MGCMapSnapShotAttributes = {
	.snapshopData = @"snapshopData",
};

const struct MGCMapSnapShotRelationships MGCMapSnapShotRelationships = {
	.loction = @"loction",
};

@implementation MGCMapSnapShotID
@end

@implementation _MGCMapSnapShot

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MapSnapshot" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MapSnapshot";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MapSnapshot" inManagedObjectContext:moc_];
}

- (MGCMapSnapShotID*)objectID {
	return (MGCMapSnapShotID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic snapshopData;

@dynamic loction;

@end


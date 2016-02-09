// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCPhoto.m instead.

#import "_MGCPhoto.h"

const struct MGCPhotoAttributes MGCPhotoAttributes = {
	.imageData = @"imageData",
};

const struct MGCPhotoRelationships MGCPhotoRelationships = {
	.notes = @"notes",
};

@implementation MGCPhotoID
@end

@implementation _MGCPhoto

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Photo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:moc_];
}

- (MGCPhotoID*)objectID {
	return (MGCPhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic imageData;

@dynamic notes;

@end


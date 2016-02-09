// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCNote.m instead.

#import "_MGCNote.h"

const struct MGCNoteAttributes MGCNoteAttributes = {
	.text = @"text",
};

const struct MGCNoteRelationships MGCNoteRelationships = {
	.location = @"location",
	.notebook = @"notebook",
	.photo = @"photo",
};

@implementation MGCNoteID
@end

@implementation _MGCNote

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Note";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Note" inManagedObjectContext:moc_];
}

- (MGCNoteID*)objectID {
	return (MGCNoteID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic text;

@dynamic location;

@dynamic notebook;

@dynamic photo;

@end


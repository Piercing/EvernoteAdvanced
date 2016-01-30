// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCNote.h instead.

@import CoreData;
#import "MGCNamedEntity.h"

extern const struct MGCNoteAttributes {
	__unsafe_unretained NSString *text;
} MGCNoteAttributes;

extern const struct MGCNoteRelationships {
	__unsafe_unretained NSString *notebook;
	__unsafe_unretained NSString *photo;
} MGCNoteRelationships;

@class MGCNotebook;
@class MGCPhoto;

@interface MGCNoteID : MGCNamedEntityID {}
@end

@interface _MGCNote : MGCNamedEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MGCNoteID* objectID;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MGCNotebook *notebook;

//- (BOOL)validateNotebook:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MGCPhoto *photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;

@end

@interface _MGCNote (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (MGCNotebook*)primitiveNotebook;
- (void)setPrimitiveNotebook:(MGCNotebook*)value;

- (MGCPhoto*)primitivePhoto;
- (void)setPrimitivePhoto:(MGCPhoto*)value;

@end

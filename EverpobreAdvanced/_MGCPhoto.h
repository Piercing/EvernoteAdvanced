// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCPhoto.h instead.

@import CoreData;

extern const struct MGCPhotoAttributes {
	__unsafe_unretained NSString *imageData;
} MGCPhotoAttributes;

extern const struct MGCPhotoRelationships {
	__unsafe_unretained NSString *notes;
} MGCPhotoRelationships;

@class MGCNote;

@interface MGCPhotoID : NSManagedObjectID {}
@end

@interface _MGCPhoto : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MGCPhotoID* objectID;

@property (nonatomic, strong) NSData* imageData;

//- (BOOL)validateImageData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *notes;

- (NSMutableSet*)notesSet;

@end

@interface _MGCPhoto (NotesCoreDataGeneratedAccessors)
- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(MGCNote*)value_;
- (void)removeNotesObject:(MGCNote*)value_;

@end

@interface _MGCPhoto (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;

- (NSMutableSet*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet*)value;

@end

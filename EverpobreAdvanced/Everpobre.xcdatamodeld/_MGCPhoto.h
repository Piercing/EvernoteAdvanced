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

@property (nonatomic, strong) MGCNote *notes;

//- (BOOL)validateNotes:(id*)value_ error:(NSError**)error_;

@end

@interface _MGCPhoto (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;

- (MGCNote*)primitiveNotes;
- (void)setPrimitiveNotes:(MGCNote*)value;

@end

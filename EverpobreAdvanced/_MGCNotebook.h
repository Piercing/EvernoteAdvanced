// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCNotebook.h instead.

@import CoreData;
#import "MGCNamedEntity.h"

extern const struct MGCNotebookRelationships {
	__unsafe_unretained NSString *notes;
} MGCNotebookRelationships;

@class MGCNote;

@interface MGCNotebookID : MGCNamedEntityID {}
@end

@interface _MGCNotebook : MGCNamedEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MGCNotebookID* objectID;

@property (nonatomic, strong) NSSet *notes;

- (NSMutableSet*)notesSet;

@end

@interface _MGCNotebook (NotesCoreDataGeneratedAccessors)
- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(MGCNote*)value_;
- (void)removeNotesObject:(MGCNote*)value_;

@end

@interface _MGCNotebook (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet*)value;

@end

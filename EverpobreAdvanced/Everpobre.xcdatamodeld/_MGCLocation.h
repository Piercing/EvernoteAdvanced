// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCLocation.h instead.

@import CoreData;

extern const struct MGCLocationAttributes {
	__unsafe_unretained NSString *address;
	__unsafe_unretained NSString *latitud;
	__unsafe_unretained NSString *longitude;
} MGCLocationAttributes;

extern const struct MGCLocationRelationships {
	__unsafe_unretained NSString *mapSnapshot;
	__unsafe_unretained NSString *notes;
} MGCLocationRelationships;

@class MGCMapSnapShot;
@class MGCNote;

@interface MGCLocationID : NSManagedObjectID {}
@end

@interface _MGCLocation : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MGCLocationID* objectID;

@property (nonatomic, strong) NSString* address;

//- (BOOL)validateAddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* latitud;

@property (atomic) double latitudValue;
- (double)latitudValue;
- (void)setLatitudValue:(double)value_;

//- (BOOL)validateLatitud:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* longitude;

@property (atomic) double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MGCMapSnapShot *mapSnapshot;

//- (BOOL)validateMapSnapshot:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *notes;

- (NSMutableSet*)notesSet;

@end

@interface _MGCLocation (NotesCoreDataGeneratedAccessors)
- (void)addNotes:(NSSet*)value_;
- (void)removeNotes:(NSSet*)value_;
- (void)addNotesObject:(MGCNote*)value_;
- (void)removeNotesObject:(MGCNote*)value_;

@end

@interface _MGCLocation (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAddress;
- (void)setPrimitiveAddress:(NSString*)value;

- (NSNumber*)primitiveLatitud;
- (void)setPrimitiveLatitud:(NSNumber*)value;

- (double)primitiveLatitudValue;
- (void)setPrimitiveLatitudValue:(double)value_;

- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;

- (MGCMapSnapShot*)primitiveMapSnapshot;
- (void)setPrimitiveMapSnapshot:(MGCMapSnapShot*)value;

- (NSMutableSet*)primitiveNotes;
- (void)setPrimitiveNotes:(NSMutableSet*)value;

@end

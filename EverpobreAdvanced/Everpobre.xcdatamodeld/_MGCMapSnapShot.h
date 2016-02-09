// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MGCMapSnapShot.h instead.

@import CoreData;

extern const struct MGCMapSnapShotAttributes {
	__unsafe_unretained NSString *snapshopData;
} MGCMapSnapShotAttributes;

extern const struct MGCMapSnapShotRelationships {
	__unsafe_unretained NSString *loction;
} MGCMapSnapShotRelationships;

@class MGCLocation;

@interface MGCMapSnapShotID : NSManagedObjectID {}
@end

@interface _MGCMapSnapShot : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MGCMapSnapShotID* objectID;

@property (nonatomic, strong) NSData* snapshopData;

//- (BOOL)validateSnapshopData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) MGCLocation *loction;

//- (BOOL)validateLoction:(id*)value_ error:(NSError**)error_;

@end

@interface _MGCMapSnapShot (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveSnapshopData;
- (void)setPrimitiveSnapshopData:(NSData*)value;

- (MGCLocation*)primitiveLoction;
- (void)setPrimitiveLoction:(MGCLocation*)value;

@end

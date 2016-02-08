#import "_MGCNote.h"

@class MGCNotebook;
@interface MGCNote : _MGCNote {}

// Propiedad para saber si una nota tiene o no una localización, con esto sabemos
//  si una nota es que no tiene geolocalización con aquellas que están en ==>(0,0)
@property(nonatomic, readonly) BOOL hasLocation;

+(instancetype) noteWithName:(NSString *) name
                    notebook:(MGCNotebook *) notebook
                     context:(NSManagedObjectContext *) context;

@end

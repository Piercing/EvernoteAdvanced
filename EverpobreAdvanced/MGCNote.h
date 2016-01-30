#import "_MGCNote.h"

@interface MGCNote : _MGCNote {}

+(instancetype) noteWithName:(NSString *) name
                    notebook:(MGCNotebook *) notebook
                     context:(NSManagedObjectContext *) context;

@end

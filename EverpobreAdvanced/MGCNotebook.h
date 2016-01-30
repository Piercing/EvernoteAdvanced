#import "_MGCNotebook.h"

@interface MGCNotebook : _MGCNotebook {}


+(instancetype) notebookWithName:(NSString *)name
                         context:(NSManagedObjectContext *) context;

@end

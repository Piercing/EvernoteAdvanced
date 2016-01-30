#import "MGCNote.h"

@interface MGCNote ()

+(NSArray *)observableKeyNames;

@end

@implementation MGCNote

+(NSArray *)observableKeyNames{
    
    return @[@"name", @"creationDate", @"notebook", @"photo"];
}

+(instancetype) noteWithName:(NSString *) name
                    notebook:(MGCNotebook *) notebook
                     context:(NSManagedObjectContext *) context{
    
    // Instancio una nota
    MGCNote *note = [NSEntityDescription insertNewObjectForEntityForName:[MGCNote entityName]
                                                  inManagedObjectContext:context];
    
    // Añado las tres propiedades que tenemos que asignarle en el momento de creación
    note.creationDate = [NSDate date];
    note.notebook = notebook;
    note.modificationDate = [NSDate date];
    
    // Devuelvo la nota
    return note;
}


@end

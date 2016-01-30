#import "MGCNotebook.h"

@interface MGCNotebook ()

// Creo un método de clase para refactorizar =>'setupKVO' y 'tearDownKVO'
+(NSArray *) observableKeyNames;

@end

@implementation MGCNotebook

+(NSArray *) observableKeyNames{
    
    return @[@"creationDate", @"name", @"notes"];
}

+(instancetype) notebookWithName:(NSString *)name
                         context:(NSManagedObjectContext *) context{
    
    // Crear instancia de libreta
    // Mogenerator nos ha creado un metodo de clase que nos
    // devuelve siempre el nombre de la entidad => entityName
    MGCNotebook *nb = [NSEntityDescription insertNewObjectForEntityForName:[MGCNotebook entityName]
                                                    inManagedObjectContext:context];
    
    // Añado las dos propiedades que tenemos que asignarle en el momento de creación
    nb.name = name;
    nb.creationDate = [NSDate date];
    nb.modificationDate = [NSDate date];
    
    // Lo devuelvo
    return nb;
}

@end

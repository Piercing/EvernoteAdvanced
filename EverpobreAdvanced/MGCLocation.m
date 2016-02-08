#import "MGCLocation.h"
#import "MGCNote.h"
@import AddressBookUI;
@import Contacts;

@interface MGCLocation ()

// Private interface goes here.

@end

@implementation MGCLocation

/*
 REAPROVECAMIENTO DE LONGITUDES
 */
+(instancetype) locationWithCLLocation:(CLLocation *)location
                               forNote:(MGCNote *)note{
    
    // Busco primero una location que tenga la misma latitud y longitud para
    // usar esa y no tener que estar creando localizaciones si ésta ya existe,
    // ahorrando el almacenar objetos del mismo tipo innecesariamente pecdorr.
    // Que no existe, pues 'antonces' sí, la creo. Para ello hago uso de los predicates.
    
    // Creo 1º el fetchRequest
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[MGCLocation entityName]];
    
    // Predicado para longitud
    NSPredicate *longitude = [NSPredicate predicateWithFormat:@"longitude == %f", location.coordinate.longitude];
    
    // Predicado para la latitud
    NSPredicate *latitude = [NSPredicate predicateWithFormat:@"latitude == %f", location.coordinate.latitude];
    
    // Predicado compuesto
    request.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[latitude, longitude]];
    
    // Hago una búsqueda //
    // Creo un error
    NSError *error = nil;
    // Array para los resultados
    NSArray *results = [note.managedObjectContext executeFetchRequest:request
                                                                error:&error];
    
    // Compruebo que no se haya producido un error
    NSAssert(results, @"Error al buscar");
    // si tiene algo aprovecho la location
    if ([results count]) {
        // Cojo el último resultado
        MGCLocation *foundLocation = [results lastObject];
        // Lo añado a la nota en cuestión
        [foundLocation addNotesObject:note];
        // La devuelvo
        return foundLocation;
    }else{
        // Que no la hay, la creo a peñote //
        // Instancio una localización
        MGCLocation *loc = [self insertInManagedObjectContext:note.managedObjectContext];
        
        // Configuro la localización
        loc.latitudValue = location.coordinate.latitude;
        loc.longitudeValue = location.coordinate.longitude;
        
        // Esta geolocalización tengo que añadirla a la nota.
        // Recordar que una localización puede estar en varias notas.
        [loc addNotesObject:note];
        
        // Añado la dirección ==> geocodificación inversa.
        CLGeocoder *coder = [[CLGeocoder alloc]init];
        
        // Obtengo la dirección en 2º plano
        [coder reverseGeocodeLocation:location
                    completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
                        // Aquí nos pasa un array de un 'Placemark' ==> parte de una geolocalización (País, ciudad, etc).
                        
                        // Compruebo que no se ha producido un error
                        if (error) {
                            NSLog(@"Error while obtaining address!|n%@", error);
                        }else{
                            // Función para obtener una cadena de salida de la localización como YODA manda.
                            // Tomo la útlima que recibo, me dejo de ostias!! :D
                            // loc.address = ABCreateStringWithAddressDictionary([[placemarks lastObject]addressDictionary], YES);
                            loc.address = CNPostalAddressFormatterStyleMailingAddress;
                        }
                    }];
        
        return loc;
    }
}

@end

#import "MGCLocation.h"
#import "MGCNote.h"
#import "MGCMapSnapShot.h"
#import <CoreLocation/CoreLocation.h>
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
    NSPredicate *longitude = [NSPredicate predicateWithFormat:@"abs(longitude) - abs(%lf) < 0.001", location.coordinate.longitude];
    
    // Predicado para la latitud
    NSPredicate *latitude = [NSPredicate predicateWithFormat:@"abs(latitude) - abs(%lf) < 0.001", location.coordinate.latitude];
    
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
        
        // Antes devolver la location, tengo que crear un 'mapSnapshot'
        // que en 2º plano estará el muchacho haciendo sus cosas, como
        // descargarse algún mapa o vaya usted a saber si no se da con
        // Yoda, es lo que tiene el segundo plano :-D => ~ lado oscuro
        loc.mapSnapshot = [MGCMapSnapShot mapSnapShotForLocation:loc];
        // Devuelvo la localización
        return loc;
    }
}

#pragma mark - MKAnnotation
// Título de la anotación
-(NSString *) title{
    
    return @"Richalll escribe una notica içi!!";
}

// Subtítulo de la anotación
-(NSString *)subtitle{
    
    // Concateno por líneas
    NSArray *lines = [self.address componentsSeparatedByString:@"\n"];
    
    // Creo cadena mutable
    NSMutableString *concat = [@"" mutableCopy];
    
    // Recorro las direcciones, las concateno y les añado un espacio en blanco
    for (NSString *line in lines) {
        [concat appendFormat:@"%@ ", line];
    }
    return concat;
}

// Devuelvo la cordenada en formato 'C' de Core Location
-(CLLocationCoordinate2D) coordinate{
    
    return CLLocationCoordinate2DMake(self.latitudValue, self.longitudeValue);
}








@end

#import "MGCLocation.h"
#import "MGCNote.h"
@import AddressBookUI;
@import Contacts;

@interface MGCLocation ()

// Private interface goes here.

@end

@implementation MGCLocation

+(instancetype) locationWithCLLocation:(CLLocation *)location
                               forNote:(MGCNote *)note{
    
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

@end

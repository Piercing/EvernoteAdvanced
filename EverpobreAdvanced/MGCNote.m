#import "MGCNote.h"
#import "MGCLocation.h"
#import "MGCPhoto.h"
@import CoreLocation;

@interface MGCNote ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
+(NSArray *)observableKeyNames;
@end

@implementation MGCNote
// Nos obliga apple a hacer un '@synthesize'
@synthesize locationManager = _locationManager;

// Implemento el getter ==> 'hasLocation', con esto se caya el compilatorrrrr
-(BOOL) hasLocation{
    // 'hasLocation' es verdadero cuando es distinto de nirrrllll
    return (nil != self.location);
}

+(NSArray *)observableKeyNames{
    
    return @[@"name", @"creationDate", @"notebook", @"photo", @"location"];
}

+(instancetype) noteWithName:(NSString *) name
                    notebook:(MGCNotebook *) notebook
                     context:(NSManagedObjectContext *) context{
    
    // Instancio una nota
    MGCNote *note = [self insertInManagedObjectContext:context];
    
    // Añado las propiedades que tenemos que asignarle en el momento de creación
    note.creationDate = [NSDate date];
    note.notebook = notebook;
    note.modificationDate = [NSDate date];
    note.name = name;
    note.photo = [MGCPhoto insertInManagedObjectContext:context];
    
    // Devuelvo la nota
    return note;
}

#pragma mark - Life cycle
-(void) awakeFromInsert{
    [super awakeFromInsert];

    // Averiguo si tiene sentido crear una localización, viendo si tengo permiso
    // Casos para tener autorización según si se cumplen los siguientes estados.
   CLAuthorizationStatus  status = [CLLocationManager authorizationStatus];
    if (((status == kCLAuthorizationStatusAuthorizedAlways) ||
         (status == kCLAuthorizationStatusNotDetermined) ||
         (status == kCLAuthorizationStatusAuthorizedWhenInUse))
        // Tiene que estar además el sistema de location autorizado por el usuario.
        && [CLLocationManager locationServicesEnabled]) {
        
        // Tengo acceso a localización ==> localización OK //
        // Instancio un nuevo 'locationManager'
        self.locationManager = [[CLLocationManager alloc] init];
        // Me hago su delegado
        self.locationManager.delegate = self;
        // Precisión ==> la menor que necesite por consumo batería
        // En este caso, la máxima, porque solo la recibo una vez.
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // Le pido que empiece con la geolocalizatiorrrnnnnnn
        [self.locationManager startUpdatingLocation];
        // Le pongo un límete de tiempo, si tarda mucho no interesa
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self zapLocationmanager];
        });
    }
}

#pragma mark - CLLocationManagerDelegate
-(void) locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // Al loro pedacadorrr, que es en pluralll ==> 'didUpdateLocationS'
    //¿Pourquoi? porque puede darse el caso de que no pueda entregarme
    // la localización a tiempo, mandándome pues, un array con todas las
    // localizaciones que tiene pendientes de entregar. Que listo el jodio.
    // La útlima del array es la güena, cuidadín que consume un egg de batery.
    
    // Por tanto lo paro
    [self zapLocationmanager];
    
    // Sólo voy a crear una location, si la nota no lo
    // tiene => toda precaución es poca amigo conductorrr
    // Por tanto sino tengo una localización => 'hasLocation'
    if (![self hasLocation]) {
        // Pillo la última localización => Risas del Argentino
        CLLocation *location = [locations lastObject];
        
        // Creo mi location ==> MGCLocation, implemento
        // =>'locationWithCLLocation' en 'MGCLocation.h'
        self.location  = [MGCLocation locationWithCLLocation: location
                                                     forNote: self];
        
    }else{
        NSLog(@"¡¡No debiera de haber llegado nunca hasta aquirrrr!!");
    }
    
    
    
}

-(void) zapLocationmanager{
    
    // Paro la geolocalización cuando se demora.
    // ¿Pourquoi? => Porque según un bug, 'locationManager'sigue
    // mandando mensajes a pesar de decirle que pare al mu jodio.
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
    self.locationManager = nil;
}









@end

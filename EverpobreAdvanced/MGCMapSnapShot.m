#import "MGCMapSnapShot.h"
#import "MGCLocation.h"
#import <MapKit/MapKit.h>

@interface MGCMapSnapShot ()

// Private interface goes here.

@end

@implementation MGCMapSnapShot

#pragma mark - Properties
// Creo la getImage
-(UIImage *) image{
    
    return [UIImage imageWithData:self.snapshopData];
}

// Creo el setImage
-(void)setImage:(UIImage *)image{
    
    self.snapshopData = UIImageJPEGRepresentation(image, 0.9);
}

#pragma mark - Class Methods
+(instancetype) mapSnapShotForLocation:(MGCLocation *)location{
    
    // Creo un 'MapSnapShot'
    MGCMapSnapShot *snap = [MGCMapSnapShot insertInManagedObjectContext:location.managedObjectContext];
    // Le paso su location
    snap.loction = location;
    // Lo devuelvo
    return snap;
}

// Necesito crear el 'snapShot'
-(void) awakeFromInsert{
    
    // Como 'awakeFromInsert' se ejecuta después de 'mapSnapShotForLocation',
    // éste último aún no va a contar con la location..... Ohhhh my good!!!!
    // Tranquilo miFrend, voy a observar la propiedad 'location' y cada vez
    // que cambie voy a recalcular el 'snapShot'. Para ello voy a activar la
    // observación en 'awakeFromInsert' y 'awakeFromfetch' y desactivarla en
    // 'willTurnIntoFault'
    [super awakeFromInsert];
    
    // Observo la propiedad 'location'
    [self starObserving];
}

-(void)awakeFromFetch{
    [super awakeFromFetch];
    
    // Observo la propiedad 'location'
    [self starObserving];
}

// Ahora me doy de baja, traquilos estoy bien,
// el que se de de baja no soy yo :-D majetes.
-(void)willTurnIntoFault{
    
    [super willTurnIntoFault];
    
    // Dejo de observar a 'location'
    [self stopObserving];
    
}

#pragma mark - KVO
// Montando el chiringuito de Pepe
-(void)starObserving{
    
    // Oservo a Pampita, digo a 'location' ejemm...
    [self addObserver:self
           forKeyPath:@"location"
              options:NSKeyValueObservingOptionNew
              context:NULL];
}

-(void)stopObserving{
    
    // Dejo de observar, siii , a 'location'
    [self removeObserver:self
              forKeyPath:@"location"];
}

// Recibo la notificación
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    
    // Como es solo una propiedad, recalculo el 'mapsanapshot'
    // Necestio un centro, lo mismo que a Yoda
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(self.loction.latitudValue,
                                                               self.loction.longitudeValue);
    
    // Necetio un objeto para configurar el creador de 'snapshot'
    MKMapSnapshotOptions *options = [MKMapSnapshotOptions new];
    options.region = MKCoordinateRegionMakeWithDistance(center, 300, 300);
    // Tipo de maparrr
    options.mapType = MKMapTypeHybrid;
    // El tamaño de la images
    options.size = CGSizeMake(175, 170);
    
    // Creo el snapshoter
    MKMapSnapshotter *shotter = [[MKMapSnapshotter alloc]initWithOptions:options];
    // Lo llamo, y el solito en 2º plano se la va descargarrr 'to'
    // Mediante un completion Block, 'nus' contará que tal le fue.
    [shotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        if (!error) {
            // Sino hay error, guardo el snapshot
            self.image = snapshot.image;
        }else{
            
            // Si lo hay, que haberlos los hailos, su existencia no tiene sentido:-(
            // ya que hemos indicado en el modelo que su existencia era obligatoriar
            // NOTA: para no enviar notificaciones 'KVO' de esta propiedad 'location'
            // no utilizamos aquí la propiedad.  Para ello contamos con unos métodos
            // que cambian el valor de una propiedad sin enviar notificaciones 'KVO',
            // y son métodos tipo 'KVC' =>'setPrimitiveValue:(id) forKey:(NSString)'.
            // Pero,  mogenerator ha creado métodos específicos para mis propiedades.
            // Con este métodorr elimino  'location' sin provocar un blucle infinito.
            [self setPrimitiveLoction:nil];
            // Por último, como el pecador location no tiene sentido, pos se suicida.
            [self.managedObjectContext deleteObject:self];
            
        }
    }];
    
    // NOTA: nos vamos a 'MGCLocation.m' para usar este 'snapshot'
    // ya que cuando se crea una locatio
    
    
    
    
}














@end

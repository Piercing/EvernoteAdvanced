#import "MGCNamedEntity.h"

@interface MGCNamedEntity ()

+(NSArray *)observableKeyNames;

@end

@implementation MGCNamedEntity

#pragma mark - Class Methods
+(NSArray *)observableKeyNames{
    return @[@"name", @"creationDate"];
}

#pragma mark - KVO (Key Value Observing)
// Observamos desde 'MGCNotebook' nuestras propias propiedades y
// cuando cualquiera de una de ellas cambie actualizamos 'modificationDate'.
// Observamos todas las propiedades excepto 'modificationDate' ya que cuando
// se modifica ésta si la vuelvo a cambiar entramos en un bucle infinito de
// notificaciones.

// Mensaje para darse de alta en las Notificaciones
-(void) setupKVO{
    
    // array con el nombre de las propiedades a observar => 'observableKeyNames'
    
    // Recorro el array con las distintas propiedades, excepto 'UILUImodificationDate'
    // ya que esta se modificará cuando las demás propiedades cambien, por tanto,
    // doy de alta en Notificaciones a 'modificationDate' para que esté al loro
    // de el cambio de resto de propiedades. Yo mismo, 'notificationDate', las observo
    // cuando haya cambios, recibo el nuevo valor y el valor antiguo de esa propiedad
    // y no quiero recibir nada cuando se produzca la notificación, por tanto, 'context' NULL.
    for (NSString *key in [[self class] observableKeyNames]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:NULL];
    }
}

// Mensaje para darse de baja en las notificaciones
-(void) tearDownKVO{
    
    // Nos damos de baja por cada una de las claves
    for (NSString *key in [[self class] observableKeyNames]) {
        [self removeObserver:self
                  forKeyPath:key];
    }
}

// Implementamos el mensaje que nos van a enviar
// cuando se va a producir el cambio en esa propiedad.

// Recibimos la clave que ha cambiado => 'KeyPath'.
// Recibimos el objeto de cuya clave ha cambiado => 'object'.
// Recibimos el cambio que es un diccionario, en el que en este
// caso nos vendráel valor nuevo y el valor antiguo => 'change'.
// Recibimos el contexto que en este caso es NULL, => 'context'.
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    
    // Me da igual que propiedad haya cambiado, lo único
    // que quiero es actualizar la fecha de modificación.
    self.modificationDate = [NSDate date];
    
}

#pragma mark - LyfeCycle (Core Data)
// Sobreescribimos los métodos de Core Data del ciclo de vida.
// NOTA: recordar que siempre hay que llamar a los dos para la
// creación => 'awakeFromInsert' y 'awakeFromFetch'.

// Mensaje que todo 'NSManagedObject' recibirá una vez en su vida.
// La primera vez lo rebirá al hacer el 'inserInto...'
-(void)awakeFromInsert{
    
    // reenvio a nuestro padre que está en los cielos => 'Super', OJO!!! no enviarlo al limbo.
    [super awakeFromInsert];
    // Montamos el chiringuito de Pepe aquí, Pepe = KVO, me doy de alta.
    [self setupKVO];
}

// Este lo recibirá 'NSManagedObject' un porrón (como el del vino)
// de veces a lo largo de su vida, siempre y cuando sea creado debido
// a una búsqueda. Si busco algo, recibe 'awakeFromFetch'.
// NOTA: se envía también cuando el objeto vuelve del estado de 'fault'
-(void)awakeFromFetch{
    
    // reenvío a super
    [super awakeFromFetch];
    // Montamos el chiringuito de Pepe aquí, Pepe = KVO, me doy de alta.
    [self setupKVO];
}

// Método que nos avisa cuando el objeto se convierte en un 'fault'.
// Te 'viá' convertir en un fistro de 'fault' => 'willTurnIntoFault'
-(void)willTurnIntoFault{
    
    // reenvío a super
    [super willTurnIntoFault];
    // Desmonto el chiringuito de Pepe. Me doy de baja.
    [self tearDownKVO];
    
}


@end

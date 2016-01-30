

#import "MGCPhoto.h"


@interface MGCPhoto ()

@end

@implementation MGCPhoto

#pragma mark - Properties
// Implemento el setter para la conversión de photo
-(void)setImage:(UIImage *)image{
    
    // Tenemos que sincronizar UIImage con imageData, es decir, que lo
    // que se va a guardar en Core Data es lo último que hemos recibido.
    // Se la paso en formato NSData que es lo que guarda Core Data.
    // Con esto Core Data ya tiene su photo de tipo NSData y tan contenta.
    self.imageData = UIImagePNGRepresentation(image);
    
}

// Implemento el getter para obtener la photo
-(UIImage *)image{
    
        // cargo imagen de tipo UIImage, ahora tengo
        // dos imagenes en memoria, ésta e 'imageData'
        return [UIImage imageWithData:self.imageData];
}


#pragma mark - Class Methods
+(instancetype) photoWithImage:(UIImage *) image
                       context:(NSManagedObjectContext *)context{
    
    // Implementamos el método de clase que nos crea una instancia de MGCPhoto
    MGCPhoto *photo = [NSEntityDescription insertNewObjectForEntityForName:[MGCPhoto entityName]
                                                    inManagedObjectContext:context];
    
    // Guardo en 'imageData' la representación de la
    // imagen que es de tipo NSdata que almacenará Core Data.
    photo.imageData = UIImageJPEGRepresentation(image, 0.9);

    // Devuelvo la foto
    return photo;
}







@end

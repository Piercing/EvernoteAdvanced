//
//  MGCNoteCellView.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 5/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCNoteCellView.h"
#import "MGCNote.h"
#import "MGCPhoto.h"

@interface MGCNoteCellView ()
@property(strong, nonatomic)MGCNote* note;
@end


@implementation MGCNoteCellView
// Creo un array con las propiedades (keys, según cocoa)
// con las propiedades que queremos observar.
+(NSArray *)keys{
    return  @[@"name",
              @"location",
              @"photo.image",
              @"location.address",
              @"modificationDate",
              @"location.latitude",
              @"location.longitude"];
}

// Me doy de alta, observando las propiedades de la nota
-(void)observeNote:(MGCNote *)note{
    
    // Cuando observo una nota, lo primero es guardarla en la propiedad
    self.note = note;
    
    // Observo ciertas propiedades de la nota
    for (NSString *key in [MGCNoteCellView keys]) {
        [self.note addObserver:self
                    forKeyPath:key
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
        
        // Sincronizo vista => modelo (nota y celda)
        [self syncWithNote];
    }
}

// Sincronizar modelo => vista (nota => celda)
-(void)syncWithNote{
    
    self.titleView.text = self.note.name;
    // Doy formato a 'modificationDate'
    NSDateFormatter *nsFmt = [[NSDateFormatter alloc]init];
    nsFmt.dateStyle = NSDateIntervalFormatterMediumStyle;
    self.modificationDateView.text = [nsFmt stringFromDate:self.note.modificationDate];
    
    UIImage *image;
    // Compruebo que la imagen que tengo que mostrar es nil
    if(self.note.photo.image == nil){
        // Cargo imagen no available
        image = [UIImage imageNamed:@"noImage.png"];
    }else{
        // Sino la que corresponda
        image = self.note.photo.image;
    }
    // Le paso la imagen de no available sino encuentra alguna foto
    self.photoView.image = image;
    
    // Si la nota tiene location
    if (self.note.hasLocation) {
        // Le añado la imagen placemark
        self.locationView.image = [UIImage imageNamed:@"placemark.png"];
        // sino, pues a nirrllll
    }else{
        self.locationView.image = nil;
    }
}

// Tengo que recibir la notificación y hacer algo, por último darme de baja

// Recibo pues la notificación
-(void)observeValueForKeyPath:(NSString *)keyPath
                     ofObject:(id)object
                       change:(NSDictionary<NSString *,id> *)change
                      context:(void *)context{
    
    // Como son pocas propiedades cada vez que cambia una las actualizo todas
    // Si furarn muchas las propiedades, me interesaría mediante el 'keyPath'
    // mirar que propiedad ha cambiado y actuar en consecuencia sólo ante esa.
    [self syncWithNote];
}

// Por útlimo me doy de baja. Esto será cuando nos manden el mensaje 'prepareForReuse'
// es decir ===> 'olvidate de la nota que ya te pasaré otra dentro de un rato'.
-(void) prepareForReuse{
    
    // Lo que tengo que hacer aquí
    self.note = nil;
    // Sincronizo con nil y los textos van a aparecer vacios y la imagen no available
    [self syncWithNote];
}









@end

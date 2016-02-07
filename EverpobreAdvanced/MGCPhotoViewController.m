//
//  MGCPhotoViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 7/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCPhotoViewController.h"
#import "MGCPhoto.h"
// Con esto importo el '.h' y añadida la framework
@import CoreImage;


@interface MGCPhotoViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
// Propiedad para guardar el modelo, que va a ser la foto
@property (nonatomic, strong) MGCPhoto * model;
@end

@implementation MGCPhotoViewController

-(id)initWithModel:(id)model{
    
    // Aseguramos que el model no puede ser nil
    NSAssert (model, @"model can't be nil");
    
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
    }
    return self;
}

#pragma mark - View Lifecycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Saco datos del modelo y se lo encasqueto en la imagen YEAH!!
    self.photoView.image = self.model.image;
}


// Ahora turno del Marques!!! hace los mismos favores que... YODA :-D
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Saco los datos de la imagen y se los encasqueto al modelo
    self.model.image = self.photoView.image;
    
}

#pragma mark - Actions
- (IBAction)takePhoto:(id)sender {
    
    // Creo el image picker
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    // Lo configuro, pregunto al dispositivo si tiene cámara
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        // Que no tiene cámara, pos vaya un iPhone de m.... ejem, que te compres uno 'güeno'
        // Nos conformaremos con el carrete
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Modifico la transición, para que no se vea la animación de arriba abajo sino horizontal
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Asigno delegado
    picker.delegate = self;
    
    // Lo muestro, utilizo método que entiende todo UIViewController
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         // Cuando termine la animación, de momento, no hago nada, a no ser que YODA......
                     }];
    
}

- (IBAction)deletePhoto:(id)sender {
    
    // Primero guardo el estado inicial, para después devolverlo a éste estado incial,
    // ya que sino, al sacar una foto nueva, va a estar con 'bounds' de 'CGRectZero'.
    CGRect oldBounds = self.photoView.bounds;
    
    // Elimino foto de la vista
    [UIView animateWithDuration:0.6
                          delay:0
                        options:0
                     animations:^{
                         self.photoView.bounds = CGRectZero;
                         self.photoView.alpha = 0;
                         // transformada afin de rotación, OJO!! desactivar autolayout
                         self.photoView.transform = CGAffineTransformMakeRotation(M_PI);
                     } completion:^(BOOL finished) {
                         self.photoView.image = nil;// termina la animación => elimino de la vista
                         self.photoView.alpha = 1;
                         self.photoView.bounds = oldBounds;
                         self.photoView.transform = CGAffineTransformIdentity;
                     }];
    
    // La elimino del modelo también
    self.model.image = nil;
}

- (IBAction)applyVintageEffect:(id)sender {
    
    // Creo un contexto de CoreImage
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // Creo una CIImage de entrada, toda image tiene la propidad 'CGImage'
    CIImage *input = [CIImage imageWithCGImage:self.model.image.CGImage];
    
    //Creo un filtro de tipo 'CIFalseColor' => aspecto antiguo
    CIFilter *old = [CIFilter filterWithName:@"CIFalseColor"];
    // Mando el mensaje'setDefaults' para asignar valores
    // por defecto para todos y cada uno de sus atributos.
    [old setDefaults];
    // Asigno la imagen de entrada
    [old setValue:input forKeyPath:kCIInputImageKey];
    
    //Creo un filtro de tipo 'CIVignette' => aspecto antiguo
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignette"];
    [vignette setDefaults];
    // Este si entiende el atributo  ==>'InputIntensity', le pongo un valor
    // grande sino no es perceptible ==> mayores de 10 para apreciar efecto
    [vignette setValue:@12 forKeyPath:kCIInputIntensityKey];
    
    // Encadeno los filtros diciéndole quien es su imagen de
    // entrada que es la salida del anterior =>'CIFalseColor'
    [vignette setValue:old.outputImage forKeyPath:kCIInputImageKey];
    
    // Obtengo imagen de salida ==> 'vignette'
    CIImage *output = [vignette outputImage];
    
    // Aplico el filtro =>¡¡cuidadín que esto es lo que consume!!
    // Para aplicarlo, necesito primero obtener un 'CGImageRef'
    // que es donde me van a meter el resultado del filtro.
    // El 'ref' indica que ya es un puntero, no lleva => '*'.
    
    // Arranco el 'activityView'
    [self.activityView startAnimating];
    // Utilizo una cola del sistema, no creo una para esto,
    // donde se aplica el filtro asíncronamente ==> 2º plano
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Obtengo imagen de salida
        CGImageRef res = [context createCGImage:output
                          // como quiero procesar, no solo una parte de la imagen,
                          // sino todo, le paso 'extent', es como un 'bounds' y demás.
                                       fromRect:[output extent]];
        // 'activityView' ==> cola principal
        dispatch_async(dispatch_get_main_queue(), ^{
            // Para el 'activity'una vez se muestra el filtro aplicado
            [self.activityView stopAnimating];
            
            // Guardo la imagen
            UIImage *img = [UIImage imageWithCGImage:res];
            self.photoView.image = img;
            
            // Libero el CGImageRef, ya que ARC no llega hasta tan bajo nivel, a manubrio toca
            CGImageRelease(res);
        });
    });
}

- (IBAction)zoomToFace:(id)sender {

    NSArray *features = [self featuresInImage:self.photoView.image];
    
    if (features) {
        CIFeature *face = [features lastObject];
        // necesito un CGRect con la posición de la cara
        CGRect faceBounds = [face bounds];
        // Creo una imagen solo con lo que hay en faceBounds
        CIImage *image = [CIImage imageWithCGImage:self.photoView.image.CGImage];
        // Creo una nueva imagen que es el zoom de la cara
        CIImage *cropping = [image imageByCroppingToRect:faceBounds];
        // LO transformo en una UIImage
        UIImage *newImage = [UIImage imageWithCIImage:cropping];
        // Por último se lo paso a la vista
        self.photoView.image = newImage;
        
    }
}

// Método al que le paso una imagen y devuelve un array con las caras.
-(NSArray *) featuresInImage:(UIImage *) image{
    
    // Contexto
    CIContext *context = [CIContext contextWithOptions:nil];
    
    // Creo el detector
    CIDetector *detector = [CIDetector
                            detectorOfType:CIDetectorTypeFace
                            context:context
                            options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    // Necesito una imagen de tipo CIIMage
    CIImage *img = [CIImage imageWithCGImage:image.CGImage];
    
    // Extraigo las features que son las caras
    NSArray *features = [detector featuresInImage:img];
    
    // Hago que devuelva nil o un array con las caras, pero no que esté vacio
    if ([features count]) {
        return  features;
    }else{
        return nil;
    }
}

#pragma mark - UIImagePickerControllerDelegate
-(void) imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // Momento crítico, pico de memoria
    
    // Saco la imagen del dictionary 'info'
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Rápidamente se lo paso a Core Data, que es el más cualificado para gestionar este tipo de
    // datos, guardarlos en disco y que caiga el pico de menoria, corriendo que viene YODDARRRR!!
    self.model.image = img;
    
    // Tengo que quitar el imagePicker de enmedio
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}












@end

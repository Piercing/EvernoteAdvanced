//
//  MGCPhotoViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 7/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCPhotoViewController.h"
#import "MGCPhoto.h"
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

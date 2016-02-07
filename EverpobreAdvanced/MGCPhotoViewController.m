//
//  MGCPhotoViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 7/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCPhotoViewController.h"
#import "MGCPhoto.h"
@interface MGCPhotoViewController ()
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
    
}

- (IBAction)deletePhoto:(id)sender {
}
@end

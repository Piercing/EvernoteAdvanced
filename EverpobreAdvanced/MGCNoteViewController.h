//
//  MGCNoteViewController.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 6/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@class MGCNote;
@class MGCNotebook;

@interface MGCNoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *modificationDateView;
@property (weak, nonatomic) IBOutlet UITextField *nameView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;


// Inicializador, necesitamos el modelo para crear notas
// NOTA: Me falla el protocolo 'Detail' y he vuelto a poner el inicializador aquí
-(id) initWithModel:(MGCNote *)model;

// Con esto estamos diciendo que nos cree un nuevo
// controlador para crear una nueva nota en tal libreta.
-(id)initForNewNoteInNotebook:(MGCNotebook *)notebook;

@end

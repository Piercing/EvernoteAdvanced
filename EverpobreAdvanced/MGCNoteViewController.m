//
//  MGCNoteViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 6/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCNoteViewController.h"
#import "MGCNote.h"
#import "MGCPhoto.h"

@interface MGCNoteViewController ()
@property(nonatomic, strong)MGCNote *model;
@end

@implementation MGCNoteViewController

#pragma mark - Init
-(id) initWithModel:(MGCNote *)model{
    
    if (self = [super initWithNibName:nil bundle:nil]){
        _model = model;
    }
    return self;
}

#pragma mark - View Lyfecicle
// La ida, cuando se vaya a mostrar la vista sincronizo modelo => vista
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Sicronizo modelo ==> vista
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateStyle = NSDateFormatterLongStyle;
    
    // muestro en el IBOutlet 'modificationDateView' la fecha de modificación de mi modelo
    self.modificationDateView.text = [fmt stringFromDate:self.model.modificationDate];
    
    self.nameView.text = self.model.name;
    self.textView.text = self.model.text;
    
    
    // Ahora la fotito dichosa
    UIImage *img = self.model.photo.image;
    if (!img) {
        img = [UIImage imageNamed:@"photography76"];
    }
    self.photoView.image = img;
    
    // Observando el teclado cuando va a aparecer
    [self starObservingKeyBoard];
    
}

// La vuelta, a la toritilla Umm rica rica!!!
// Cuando va a desaparecer la imagen el usuario ha
// podido editar algo, la imagen por ejemplo y el
// texto, por tanto sincoronizo vista ==> modelo.
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Vista ==> modelo
    self.model.text = self.textView.text;
    self.model.photo.image = self.photoView.image;
    
    // Observando el teclado cuando va a desaparecer
    [self stopObservingKeyBoard];
    
}

#pragma mark - Keyboard
-(void)starObservingKeyBoard{
    
    // Necesito un notification center
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // Me doy de alta y observo cuando aparece y desaparece el teclado
    
    // Cuando aparece
    [nc addObserver:self
           selector:@selector(notifyThatKeyboardWillAppear:)
               name:UIKeyboardWillShowNotification
             object:nil];
    
    // Cuando desaparece
    [nc addObserver:self
           selector:@selector(notifyThatKeyboardWillDissappear:)
               name:UIKeyboardWillHideNotification
             object:nil];
    
}

-(void)stopObservingKeyBoard{
    
    // Necesito un notification center
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    // Me doy de baja ==> dejo de observar el teclado.
    [nc removeObserver:self];
    
}

-(void)notifyThatKeyboardWillAppear:(NSNotification *) notification{
    
    // Extraer el userInfo de la notificación que nos llega y lo
    // guardo en un NSDIctionary ==> Quien envía la notificación.
    NSDictionary *dict = notification.userInfo;
    
    // Extraer la duración de la animanción: para ello lo extraigo del diccionario donde
    // se ha guardado la clave de dicho objeto (el teclado) y mediante el método de clase
    // 'UIKeyboardAnimationDurationUserInfoKey' obtengo la duración de ese objeto ==> teclado.
    double duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    // Cambiar el Frame, las propiedades, de la caja de texto
    // y le doy animación ('pa' que no se aburra el muchacho).
    [UIView animateWithDuration:duration
                          delay:0
                        options:0
                     animations:^{
                         // Hago que el teclado suba a la posición del frame superior izquierdo donde se encuentra'modificationDateView'
                         self.textView.frame = CGRectMake(self.nameView.frame.origin.x,
                                                          self.nameView.frame.origin.y,
                                                          self.view.frame.size.width,
                                                          self.view.frame.size.height);
                     } completion:nil];
    
    // Añado otra animación para cambiarle el alfa
    [UIView animateWithDuration:duration
                          delay:0
                        options:0
                     animations:^{
                         
                         self.textView.alpha = 0.8;
                     } completion:nil];
    
}

-(void)notifyThatKeyboardWillDissappear:(NSNotification *)notification{
    
    // Extraer el userInfo de la notificación que nos llega y lo
    // guardo en un NSDIctionary ==> Quien envía la notificación.
    NSDictionary *dict = notification.userInfo;
    
    
    double duration = [[dict objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:0
                     animations:^{
                         
                         self.textView.frame = CGRectMake(0,
                                                          375,
                                                          self.view.frame.size.width,
                                                          self.textView.frame.size.height);
                     } completion:nil];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:0
                     animations:^{
                         
                         self.textView.alpha = 1;
                     } completion:nil];
    
}


#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

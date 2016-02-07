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
#import "MGCNotebook.h"

@interface MGCNoteViewController ()
@property (nonatomic, strong) MGCNote *model;
// Flag para indicar que estamos mostrando una nota nueva
// Hay que poner el botón de cancelar
@property (nonatomic) BOOL new; //Por defecto falso => NO
// Flag para cuando se haya borrado alguna nota
@property (nonatomic) BOOL deleteCurrentNote;
@end

@implementation MGCNoteViewController

#pragma mark - Init
-(id) initWithModel:(MGCNote *)model{
    
    if (self = [super initWithNibName:nil bundle:nil]){
        _model = model;
    }
    return self;
}

-(id)initForNewNoteInNotebook:(MGCNotebook *)notebook{
    
    // Creo una nueva nota vacía dentro de esta libreta y
    // le repasamos el marrón al 'initWithModel' de arriba.
    
    MGCNote *newNote = [MGCNote noteWithName:@""// sin nombre
                                    notebook:notebook // la libreta que recibo
                                     context:notebook.managedObjectContext];// le pido el contexto a la libreta
    // Al crear una nueva nota la flag cambia a YES, con esto sabemos que estamos creando una nueva nota.
    _new = YES;
    // Devuelvo la nueva nota inicializada a los valores que le acabo de pasar
    return [self initWithModel:newNote];
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
    
    // Llamo al accessoryView para que meta la barra de botones (DONE).
    [self setupInputAccessoryView];
    
    // Comprobamos si se ha creado una nueva nota
    if (self.new) {
        // Entonces mostramos el botón de cancelar
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                   target:self
                                   action:@selector(cancel:)];
        
        // Añado el botón a la UI
        self.navigationItem.rightBarButtonItem = cancel;
        
    }
    
}



// La vuelta, a la toritilla Umm rica rica!!!
// Cuando va a desaparecer la imagen el usuario ha
// podido editar algo, la imagen por ejemplo y el
// texto, por tanto sincoronizo vista ==> modelo.
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Elimino la nota
    if (self.deleteCurrentNote) {
        // Para borrar un objeto de Core Data, al contexto le mandamos
        // el mensaje 'deleteObject' y le paso la referencia al objeto.
        // El contexto estará en el modelo
        // Obtengo el contexto con 'self.model.managedObjectContext'
        // y le mando el mensaje 'deleteObject' y elimino el objeto
        // que es precisamente el modelo 'self.model', que es la nota en sí.
        [self.model.managedObjectContext deleteObject:self.model];
    }else{
        // Sino, sicronizo vista ==> modelo, guardando los datos
        self.model.text = self.textView.text;
        self.model.photo.image = self.photoView.image;
    }
    
    
    
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
                         self.textView.frame = CGRectMake(self.modificationDateView.frame.origin.x,
                                                          self.modificationDateView.frame.origin.y,
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

// Creo la accesoryView, una barra de botones
// ==>teclado con una barra de botones encima
-(void) setupInputAccessoryView{
    
    // Creo una barra
    UIToolbar *bar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    // Añado botones == 'DONE' (listo)
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(dismissKeyboard:)];
    
    
    // Creo un separador para que aparezca a la derecha el botón de DONE.
    UIBarButtonItem *separator = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    
    
    // Insertando 'smiles' (emoticonos) en el teclado
    UIBarButtonItem *smile = [[UIBarButtonItem alloc]initWithTitle:@"O_O "
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(insertTitle:)];
    
    UIBarButtonItem *smile2 = [[UIBarButtonItem alloc]initWithTitle:@"X_X "
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(insertTitle:)];
    
    // Creo un array con los botones que quiero meter en la barra.
    [bar setItems:@[smile, smile2, separator, done]];
    
    // La asigno como 'accessoryInputView'
    self.textView.inputAccessoryView = bar;
}

// Recibe un BarButtonItem
-(void)insertTitle:(UIBarButtonItem *)sender{
    
    // Insertando una cadena donde esté el punto de inserción en el textView
    // El texto que insertamos es el que me viene en el 'sender'
    [NSString stringWithFormat:@"%@",  @" "], [self.textView insertText:sender.title];
    
}
-(void)dismissKeyboard: (id)sender{
    [self.view endEditing:YES];
    
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Utils
-(void) cancel:(id) sender{
    
    // Tengo que indicar que hay que eliminar la nota
    // actual con la flag 'deleteCurrentNote' ==> YES
    self.deleteCurrentNote = YES;
    
    // Hago un pop, y ya no hay STOP :-D
    // Al hacer el pop, se va a ejecutar ViewWillDisapper
    [self.navigationController popViewControllerAnimated:YES];
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

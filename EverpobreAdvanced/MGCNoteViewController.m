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
#import "MGCPhotoViewController.h"
#import "MGCLocation.h"
#import "MGCMapSnapShot.h"
#import "MGCLocationViewController.h"

@interface MGCNoteViewController () <UITextFieldDelegate, UITextViewDelegate>
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
        img = [UIImage imageNamed:@"noImage.png"];
    }
    self.photoView.image = img;
    
    // // Ahora snapshot dichoso
    img = self.model.location.mapSnapshot.image;
    // Si tengo location 'smapshot => YES
    //self.mapSnapshotView.userInteractionEnabled = YES;
    // Sino tengo imagen, tiro de la que acabo de incorporar =>'img'
    if (!img) {
        img = [UIImage imageNamed:@"noSnapshot.png"];
        // Sino tengo location 'smapshot => NO
        //self.mapSnapshotView.userInteractionEnabled = NO;
    }
    
    // Se lo paso a la imagen
    self.mapSnapshotView.image = img;
    
    // Como este 'snapshot' se obtiene en 2º plano
    // podría ser que aún no tuviera la imagen, por
    // tanto, la observo para si cambia enterarme.
    [self startObservingSnapshot];
    
    
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
    // Me hago delegado de 'UITextField' ==> 'nameView'
    // y de 'UITexView' ==> 'textView'
    self.nameView.delegate = self;
    self.textView.delegate = self;
    
    // Añado un gesture recognizer a la foto
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                         action:@selector(displayDetailPhoto:)];
    
    [self.photoView addGestureRecognizer:tap];
    
    // Añado botón de compartir nota
    UIBarButtonItem *share = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                          target:self
                                                                          action:@selector(displayShareController:)];
    
    
    // Añado gesture recognizer para vista de 'location'
    
    UITapGestureRecognizer *snapTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(displayDetailLocation:)];
    
    // Lo añado el gesto
    [self.mapSnapshotView addGestureRecognizer:snapTap];
    
    // Añado el botón de compartir
    self.navigationItem.rightBarButtonItem = share;
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
        self.model.name = self.nameView.text;
    }
    // Dejar de observar el teclado cuando va a desaparecer.
    [self stopObservingKeyBoard];
    [self stopObservingSnapshot];
    
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
    
    
    // Averiguo quien es el 'firstResponder' de la vista para que cuando
    // edito el 'textField' al aparecer el teclado no me suba la vista
    // como hace cuando edito en el 'textView' que ahí si hace falta.
    if ([self.textView isFirstResponder]) {
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
}

-(void)notifyThatKeyboardWillDissappear:(NSNotification *)notification{
    
    // Preguntando quien es el 'firstResponder' aquí, solo se va a producir
    // la subida y bajada, si el 'firstResponder' es el 'textView' y no con el 'textField'
    if ([self.textView isFirstResponder]) {
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
}

// Creo la accesoryView, una barra de botones
// ==>teclado con una barra de botones encima
-(void) setupInputAccessoryView{
    
    // Creo las barras
    UIToolbar *textBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.textView.frame.size.width, 44)];
    UIToolbar *nameBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.textView.frame.size.width, 44)];
    
    // BOTONES
    
    // Creo un separador para que aparezca a la derecha el botón de DONE.
    UIBarButtonItem *separator = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    // Añado botones == 'DONE' (listo)
    UIBarButtonItem *done = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                         target:self
                                                                         action:@selector(hideKeyboard:)];
    
    UIBarButtonItem *done2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                          target:self
                                                                          action:@selector(hideKeyboard:)];
    // Insertando 'smiles' (emoticonos) en el teclado
    UIBarButtonItem *smile = [[UIBarButtonItem alloc]initWithTitle:@";-)"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(insertTitle:)];
    
    UIBarButtonItem *smile2 = [[UIBarButtonItem alloc]initWithTitle:@"X_X"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(insertTitle:)];
    
    // Creo un array con los botones que quiero meter en la barra.
    [textBar setItems:@[smile, smile2, separator, done]];
    [nameBar setItems:@[separator, done2]];
    
    // Las asigno como 'accessoryInputView'
    self.textView.inputAccessoryView = textBar;
    self.nameView.inputAccessoryView = nameBar;
}

// Recibe un BarButtonItem
-(void)insertTitle:(UIBarButtonItem *)sender{
    
    // Insertando una cadena donde esté el punto de inserción en el textView
    // El texto que insertamos es el que me viene en el 'sender'
    [self.textView insertText:[NSString stringWithFormat:@"%@ ", sender.title]];
    
}
-(void)hideKeyboard: (id)sender{
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

#pragma mark - UITextFieldDelegate
// Podría esto retornar...
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    // Podríamos validar el texto, validar lo que se
    // ha escrito, acepto de momento cualquier cosa.
    // A textField le mando el siguiente mensaje:
    [textField resignFirstResponder];
    // Devuelvo YES.
    // Con esto ya podemos deshacernos del teclado
    return YES;
}

#pragma mark - Actions
-(void)displayDetailPhoto:(id)sender{
    
    // Aqui muestro un MGCPhotoViewController haciendo un push
    // Al inicar con 'initWithModel' asegurarse de que nunca
    // pasamos nil, hay que asegurarse de que esa foto tiene
    // una relación con la nota, para ello pasar una foto, que
    // en el peor de los casos una foto sin imagen, pero hay
    // pasar siempre una instancia de la clase MGCPhoto, no nil.
    // Para ello hago una comprobación inicial, si apunta a nil
    // le asigno una foto vacía.
    if (self.model.photo == nil) {
        self.model.photo = [MGCPhoto photoWithImage:nil// aquí si puedo pasarle nil
                                            context:self.model.managedObjectContext];
    }
    // Creo controlador de tipo foto
    MGCPhotoViewController *photoVC = [[MGCPhotoViewController alloc]initWithModel:self.model.photo];
    
    // Lo pusheo
    [self.navigationController pushViewController:photoVC
                                         animated:YES];
    
}

-(void)displayDetailLocation:(id) sender{
    
    // Creo un controlador
    MGCLocationViewController *locVC = [[MGCLocationViewController alloc]initWithLocation:self.model.location];
    // Hago un push
    [self.navigationController pushViewController:locVC
                                         animated:YES];
}

-(void)displayShareController:(id)sender{
    
    // Creo un UIACtivityController, tengo que pasarle un array con las
    // propiedades que quiero compartir de la nota y ninguna puede ser nil
    // Creo un método ==> 'arrayOfItems'
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]
                                            initWithActivityItems:[self arrayOfItems]
                                            applicationActivities:nil];// ==> nil: no aporto ninguna acción personalizada.
    // Lo presento
    [self presentViewController:activityVC
                       animated:YES
                     completion:nil];
}

-(NSArray *) arrayOfItems{
    
    // Comprobamos que propiedades no son nil y las metemos en el array
    
    // Creo array mutable
    NSMutableArray *items = [NSMutableArray array];
    
    // Comprobando
    if (self.model.name) {
        [items addObject:self.model.name];
    }
    
    if (self.model.text) {
        [items addObject:self.model.text];
    }
    
    if (self.model.photo.image) {
        [items addObject:self.model.photo.image];
    }
    return items;
}

#pragma mark - KVO
// Me doy de alta para obeservar los datos
-(void)startObservingSnapshot{
    // Observo si cambian los datos => 'location.mapSnapshot.snapshotData'
    // Yo, el modelo, que soy quien tiene esa propiedad, quiero observarla.
    [self.model addObserver:self
                 forKeyPath:@"location.mapSnapshot.snapshotData"
                    options:NSKeyValueObservingOptionNew
                    context:NULL];
}

// Y por supuesto me doy de baja, a él a él
-(void) stopObservingSnapshot{
    
    // Yo, el modelo, que soy quien tiene esa propiedad, quiero observarla.
    [self.model removeObserver:self
                    forKeyPath:@"location.mapSnapshot.snapshotData"];
}

// Por último, tengo que ser informado de que ha cambiado, SI SEÑOR SI!!!
-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context{
    
    UIImage *img = self.model.location.mapSnapshot.image;
    // Si tengo location 'smapshot => YES
    //self.mapSnapshotView.userInteractionEnabled = YES;
    // Sino tengo imagen, tiro de la que acabo de incorporar =>'img'
    if (!img) {
        // Sino tengo location 'smapshot => NO
        //self.mapSnapshotView.userInteractionEnabled = NO;
        img = [UIImage imageNamed:@"noSnapshot.png"];
    }
    
    // Se lo paso a la imagen
    self.mapSnapshotView.image = img;
    
}




@end



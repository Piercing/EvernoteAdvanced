//
//  MGCNotebooksViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 29/1/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCNotebooksViewController.h"
#import "MGCNotebook.h"
#import "MGCNotebookCellView.h"
#import "MGCNotesTableViewController.h"
#import "MGCNote.h"
#import "MGCNotesViewController.h"

@interface MGCNotebooksViewController ()

@end

@implementation MGCNotebooksViewController

#pragma mark - View Lifecycle
-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // cambio el título por defecto
    self.title = @"Everpobre Advanced";
    
    // Crear un botón, con un target y un action para añadir libretas
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addNotebook:)];
    
    
    // lo añadimos a la barra de navegación
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Pongo el botón de edición
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // Alta en notificación en sensor de proximidad ==> singleton
    UIDevice *device = [UIDevice currentDevice];
    
    if([self hasProximitySensor]){
        // Intenta detectar cambios en el estado de proximidad
        [device setProximityMonitoringEnabled:YES];
        
        // Dar de alta en una notificación => singleton
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        // Yo mismo soy el observador
        [center addObserver:self selector:@selector(proximityStateDidChanges:) name:UIDeviceBatteryLevelDidChangeNotification object:nil];
        
    }
    
    // Aquí, antes de que aparezca la celda, registro el nib,
    // podíamos haber rigistrado la clase en vez del nib.
    // Creo una instancia del nib
    UINib *cellNib = [UINib nibWithNibName:@"MGCNotebookCellView"
                                    bundle:nil];
    
    // Registro el nib con la tabla y con lel identificador de celda que es
    // el que hemos creado como un método de clase en la celda ==> 'cellId'.
    [self.tableView registerNib:cellNib
         forCellReuseIdentifier:[MGCNotebookCellView cellId]];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // Me doy de baja
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

#pragma mark - Actions
// IBAction = void
-(void)addNotebook:(id) sender{
    
    // Creo instancia de AGTNotebook y automágicamente Core Data actualiza las vistas
    // Lo hacía con el mensaje ese tan largo que le pasaba un array con tres mensajes.
    [MGCNotebook notebookWithName:@"New Notebook"
     // Para crear un objeto de Core Data hay que pasarle el contexto
     // y todo objeto de Core Data sabe en que contexto se ha creado,
     // incluido  ==> 'fetchedResultsController.managedObjectContext'.
                          context:self.fetchedResultsController.managedObjectContext];
    
    
}
#pragma mark - Data Source
// Para eliminar o añadior una libreta lo hacemos aquí, ya que estamos cambiando la fuente de datos.

// Para eliminar una celda (libreta), tengo que sobreescribir un método que me avisa que el usuario a
//  eliminado una celda (o añadir), por lo tanto tengo que eliminar (o añadir) la libreta correspondiente.
-(void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //
    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        // Averiguo de que libreta se trata
        MGCNotebook *delete = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        // La quito del modelo, para ello tengo que enviarle un
        // mensaje al 'managedObjectContext' para que elimine el objeto lo obtengo
        // de nuevo a través del ==> fetchedResultsController.managedObjectContext'.
        [self.fetchedResultsController.managedObjectContext deleteObject:delete];
        
    }
}


-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar el notebook
    MGCNotebook *nb = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    // Crear una celda
    MGCNotebookCellView *cell = [tableView dequeueReusableCellWithIdentifier:[MGCNotebookCellView cellId]];
    
    // Sincronizar libreta => celda
    cell.nameView.text = nb.name;
    cell.numberOfNotesView.text = [NSString stringWithFormat:@"%lu", (unsigned long)nb.notes.count];
    
    // Devolver la celda
    return cell;
}

#pragma mark - Table Delegate
// Configurar la altura de la celda que le dimos al crear el XIB => 60
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Llamamo al método 'cellHeight' que contiene la altura de la celda.
    return [MGCNotebookCellView cellHeight];
}

// Implemento el método 'didSelectRowAtIndexPath' para mostrar las notas
// en una nueva collectionView, cuando el usuario ha seleccionado alguna libreta.
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Creo fetch request.
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[MGCNote entityName]];
    // Lo ordeno, por nombre, fecha de creación y modificación.
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.name
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.modificationDate
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.creationDate
                                                              ascending:NO]];
    
    // Modifico el'FetchRequest' para que no pille todos los objetos
    // que responde al 'FetchRequest', sino hacerlo por lotes cogiendo
    // por ejemplo, los 20 primeros. Tamaño de lotes =>'fetchBatchSize'
    // Le indico que cargue el doble de lo que va a mostrar, si caben
    // unas diez celdas en la vista de la tabla le indico el doble: 20.
    // Tendrá efecto a medida que vayan creciendo las libretas y notas.
    // MEJORAMOS ASÍ EL USO DE MOMORIA Y EL RENDIMIENTO DEL DISPOSITIVO.
    request.fetchBatchSize = 20;
    
    // Añado predicados para filtrar las notas a mostrar
    // 'notebook' tiene que ser igual a la libreta sobre la que hemos tocado.
    // Esto lo podemos saber mediante el 'indexpath'
    request.predicate = [NSPredicate predicateWithFormat:@"notebook == %@", [self.fetchedResultsController objectAtIndexPath:indexPath]];
    
    // Crear le fetched Results Controller
    NSFetchedResultsController *nsFRC = [[NSFetchedResultsController alloc]initWithFetchRequest:request
                                                                           managedObjectContext:self.fetchedResultsController.managedObjectContext
                                                                             sectionNameKeyPath:nil cacheName:nil];
    
    // Creo el layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(192, 150);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    // Crear el controlador de notas
    MGCNotesViewController *notesVC = [MGCNotesViewController coreDataCollectionViewControllerWithFetchedResultsController:nsFRC
                                                                                                                    layout:layout];
    
    // Después de crearlo le pasamos a la propiedad 'notebook'
    // creada en 'MGCNotesViewController' => la libreta seleccionada.
    notesVC.notebook = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Lo pusheo
    [self.navigationController pushViewController:notesVC
                                         animated:YES];
    
    
}


#pragma mark - Proximity Sensor
-(void)setupProximitySensor{
    
    UIDevice *dev = [UIDevice currentDevice];
    
    if ([self hasProximitySensor]) {
        [dev setProximityMonitoringEnabled:YES];
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        
        [center addObserver:self
                   selector:@selector(proximityStateDidChanges:)
                       name:UIDeviceProximityStateDidChangeNotification
                     object:nil];
    }
}

// Detectar si hay o no un detector de proximidad
-(BOOL)hasProximitySensor{
    
    UIDevice *dev =[UIDevice currentDevice];
    BOOL oldValue = [dev isProximityMonitoringEnabled];
    [dev setProximityMonitoringEnabled:!oldValue];
    BOOL newValue = [dev isProximityMonitoringEnabled];
    
    [dev setProximityMonitoringEnabled:oldValue];
    
    return (oldValue != newValue);
}
// UIDeviceBatteryLevelDidChangeNotification
-(void)proximityStateDidChanges:(NSNotification *)notification{
    
    [self.fetchedResultsController.managedObjectContext.undoManager undo];
}



@end

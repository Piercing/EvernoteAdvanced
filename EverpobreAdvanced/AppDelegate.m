//
//  AppDelegate.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 26/1/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTSimpleCoreDataStack.h"

#import "Settings.h"
#import "MGCLocation.h"
#import "MGCNote.h"
#import "MGCNotebook.h"
#import "MGCNotebooksViewController.h"
#import "UIViewController+Navigation.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Crear una instancia del stack de Core Data
    self.model = [AGTSimpleCoreDataStack coreDataStackWithModelName:@"Everpobre"];
    
    if(ADD_DUMMY_DATA){
        [self addDummyData];
        //[self predicatesNotebooks];
        
        // Inicio el inspector Gadget, noo el del contexto
        [self printContextState];
    }
    
    
    // Auto guardado
    [self autoSave];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Necesito el 'fetchedResultsController', pero para ello necesito primero un 'fechedRequest' => consulta
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[MGCNotebook entityName]];
    
    // No creo un predicado, porque quiero todas las libretas y ordenadas
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.modificationDate
                                                              ascending:NO],
                                [NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.name
                                                              ascending:YES]];
    
    // Modifico el'FetchRequest' para que no pille todos los objetos
    // que responde al 'FetchRequest', sino hacerlo por lotes cogiendo
    // por ejemplo, los 20 primeros. Tamaño de lotes =>'fetchBatchSize'
    // Le indico que cargue el doble de lo que va a mostrar, si caben
    // unas diez celdas en la vista de la tabla le indico el doble: 20.
    // Tendrá efecto a medida que vayan creciendo las libretas y notas.
    // MEJORAMOS ASÍ EL USO DE MOMORIA Y EL RENDIMIENTO DEL DISPOSITIVO.
    request.fetchBatchSize = 20;
    
    // Creo el 'fetchedResultsController'
    NSFetchedResultsController *results = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                              managedObjectContext:self.model.context
                                                                                sectionNameKeyPath:nil
                                                                                         cacheName:nil];
    
    // Creo una instancia del controlador pasándole el 'fetchedResultsController'
    MGCNotebooksViewController *nbVC = [[MGCNotebooksViewController alloc]
                                        initWithFetchedResultsController:results
                                        style:UITableViewStylePlain];
    
    
    // Lo pongo como 'rootViewController' de nuestra 'windows'
    // pasándole la categoría 'wrappedInNavigation' empaquetada.
    self.window.rootViewController = [nbVC wrappedInNavigation];
    
    // Muestro la window
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    // Dejamos de ser la aplicación activa, marditos roeores, a guardar que lo llaman al pollo.
    [self save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    // Buen momento para guardar cuando el usuario nos abandona, Sniff....
    [self save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"¿Y quieres que guarde aquí? va a ser que no!!!");
}


#pragma mark - Utils
-(void) addDummyData{
    
    // Antes de añadir datos destruyo lo que hay en la BBDD
    // así siempre tengo la misma cantidad de datos en el BBDD.
    [self.model zapAllData];
    
    // Creo una libreta y le paso dos notas
    MGCNotebook *novias = [MGCNotebook notebookWithName:@"Ex-novias para el recuerdo de hace unos años"
                                                context:self.model.context];
    
    // Creo Notas
    [MGCNote noteWithName:@"Camila Dávalos"
                 notebook:novias
                  context:self.model.context];
    
    [MGCNote noteWithName:@"Marina Dávalos"
                 notebook:novias
                  context:self.model.context];
    
    [MGCNote noteWithName:@"Pampita"
                 notebook:novias
                  context:self.model.context];
    
    [MGCNote noteWithName:@"Pompita"
                 notebook:novias
                  context:self.model.context];
    
    [MGCNote noteWithName:@"La de la fusta"
                 notebook:novias
                  context:self.model.context];
    
    
    // Creo una libreta y le paso dos notas
    MGCNotebook *lugares = [MGCNotebook notebookWithName:@"Lugares muy extraños, cosas 'mu' chungas pedadorrrr!!"
                                                 context:self.model.context];
    
    // Creo Notas
    [MGCNote noteWithName:@"Tirando pal monte, casi me pilla una cabra"
                 notebook:lugares
                  context:self.model.context];
    
    [MGCNote noteWithName:@"Bajando del monte tres cuartos de lo mismo, 'mardita' cabra :-("
                 notebook:lugares
                  context:self.model.context];
    
    [MGCNote noteWithName:@"Ya no fui más pal monte, a las malas prefiero a Yoda que no tiene cuernos :D"
                 notebook:lugares
                  context:self.model.context];
    
    [MGCNote noteWithName:@"De esto ni mú.... que sus doy pal pelo majetes!!!!"
                 notebook:lugares
                  context:self.model.context];
    
    MGCNotebook *otrosLugares = [MGCNotebook notebookWithName:@"Lugares donde me han pasado cosas raras"
                                                      context:self.model.context];
    
    [MGCNote noteWithName:@"Puerta del Sol"
                 notebook:otrosLugares
                  context:self.model.context];
    
    [MGCNote noteWithName:@"Tatooine"
                 notebook:otrosLugares
                  context:self.model.context];
    
    [MGCNote noteWithName:@"Dantooine"
                 notebook:otrosLugares
                  context:self.model.context];
    
    [MGCNote noteWithName:@"Solaria"
                 notebook:otrosLugares
                  context:self.model.context];
    
    // Guardo
    [self save];
    
}

-(void)trastearConDatos{
    
    // Añadir
    [self addDummyData];
    
    // Buscando datos
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[MGCNote entityName]];
    
    // Ordeno los resultados con 'sortDescriptors' que acepta un array de
    // 'sortDescriptors' => descripción de como ordenadar datos en Cocoa.
    // Nos pide dos cosas, la propiedad por la cual ordenar y si queremos
    // que lo haga en orden ascendente o en orden ascendente. Como es un
    // array podemos poner tantos criterios como a mi me de la gana JARRLL.
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.name
                                                              ascending:YES],
                                [NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.modificationDate
                                                              ascending:NO]];
    
    // NOTA: mejor que esto lo haga Core Data
    // Le decimos el límite de notas que queremos
    // Que nos muestre las diez primeras notas.
    // request.fetchLimit = 10;
    
    // Dámelas en grupos de 10 en 10
    // request.fetchBatchSize = 10;
    
    NSError *error = nil;
    NSArray *results = [self.model.context executeFetchRequest:request
                                                         error:&error];
    
    if (results == nil) {
        NSLog(@"Error al buscar: %@", results);
    }else{
        NSLog(@"Results %@", results);
    }
}

-(void)save{
    
    [self.model saveWithErrorBlock:^(NSError *error) {
        NSLog(@"Error al guardar %s \n\n %@", __func__, error);
    }];
}

-(void)autoSave{
    
    if (AUTO_SAVE) {
        
        NSLog(@"Autoguardandorrr....");
        
        // Guardo
        [self save];
        
        // Se ejecuta el código pasado => 'AUTO_SAVE_DELAY_IN_SECONDS'
        // Llamada recursiva con retraso.
        [self performSelector:@selector(autoSave)
                   withObject:nil
                   afterDelay:AUTO_SAVE_DELAY_IN_SECONDS];
    }
}


#pragma mark - Predicate Playground

-(void) predicatesNotebooks{
    
    // Predicado para todas las novias de la libreta ex-novias.
    NSPredicate *novias = [NSPredicate predicateWithFormat:@"notebook.name == 'Ex-novias para el recuerdo de hace unos años'"];
    
    // Predicate compuesto sólo para las Dávalos
    NSPredicate *davalos =  [NSCompoundPredicate andPredicateWithSubpredicates:@[novias,
                                                                                 [NSPredicate predicateWithFormat:@"name ENDSWITH[cd] 'davalos' "]]];
    // Predicate compuesto sólo para Pampita
    NSPredicate *pampita = [NSCompoundPredicate andPredicateWithSubpredicates:@[novias,
                                                                                [NSPredicate predicateWithFormat:@"name CONTAINS[cd] 'pampita'"]]];
    
    // Creo el Fetch request => Las pecadorasrrrr
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[MGCNote entityName]];
    
    // Selecciono las ex-novias
    request.predicate = novias;
    
    // Creo un array para los resultados
    NSArray *results = [self.model executeRequest:request
                                        withError:^(NSError *error) {
                                            NSLog(@"Error buscando %@", request);
                                        }];
    
    // Muestro los objetos de la búsqueda
    NSLog(@"Novias: \n %@", results);
    
    // Mostar sólo las Dávalos, para ello creo el predicate 'davalos' antes
    request.predicate = davalos;
    results = [self.model executeRequest:request
                               withError:^(NSError *error) {
                                   NSLog(@"Error buscando a las chiquillas %@, cachis en la mar...", request);
                                   
                               }];
    
    NSLog(@"Dávalos:\n %@", results);
    
    // Pampita
    request.predicate = pampita;
    results = [self.model executeRequest:request
                               withError:^(NSError *error) {
                                   NSLog(@"Error al buscar %@", request);
                               }];
    
    NSLog(@"Pampita:\n %@", results);
    
    
}

-(void) printContextState{
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MGCNotebook entityName]];
    NSUInteger numNotebooks = [[self.model executeRequest:req
                                                withError:nil] count];
    
    req = [NSFetchRequest fetchRequestWithEntityName:[MGCNote entityName]];
    NSUInteger numNotes = [[self.model executeRequest:req
                                            withError:nil] count];
    
    req = [NSFetchRequest fetchRequestWithEntityName:[MGCLocation entityName]];
    NSUInteger numLocations = [[self.model executeRequest:req
                                                withError:nil] count];
    
    printf("----------------------------------------------------\n");
    printf("Total number of objects:    %lu\n", (unsigned long)self.model.context.registeredObjects.count);
    printf("Number of notebooks:        %lu\n", (unsigned long)numNotebooks);
    printf("Number of notes:            %lu\n", (unsigned long)numNotes);
    printf("Number of locations:        %lu\n", (unsigned long)numLocations);
    printf("----------------------------------------------------\n\n\n");
    
    [self performSelector:@selector(printContextState)
               withObject:nil
               afterDelay:5];
    
}


@end
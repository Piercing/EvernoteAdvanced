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
#import "MGCNote.h"
#import "MGCNotebook.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    // Creo una instancia del stack de Core Data
    self.model = [AGTSimpleCoreDataStack coreDataStackWithModelName:@"Everpobre"];
    [self createDummyData];
    
    // Auto guardado
    [self autoSave];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // Dejamos de ser la aplicación activa, marditos roeores, a guardar que lo llaman al pollo.
    [self save];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Buen momento para guardar cuando el usuario nos abandona, Sniff....
    [self save];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"¿Y quieres que guarde aquí? va a ser que no!!!");
}

#pragma mark - Utils
-(void) createDummyData{
    
    // Creo una libreta y le paso dos notas
    MGCNotebook *novias = [MGCNotebook notebookWithName:@"Ex-novias para el recuerdo"
                                                context:self.model.context];
    
    // Creo Notas
     [MGCNote noteWithName:@"Camila Dávalos"
                 notebook:novias
                  context:self.model.context];
    
   MGCNote *pampita = [MGCNote noteWithName:@"Pampita"
                 notebook:novias
                  context:self.model.context];
    
    // No hace falta guardar primero para poder buscar un objeto,
    // por tanto ya podemos buscar aquí aunque guarde más abajo.
    NSFetchRequest * request = [[NSFetchRequest alloc]initWithEntityName:[MGCNote entityName]];
    // Ordeno los resultados con 'sortDescriptors' que acepta un array de
    // 'sortDescriptors' => descripción de como ordenadar datos en Cocoa.
    // Nos pide dos cosas, la propiedad por la cual ordenar y si queremos
    // que lo haga en orden ascendente o en orden ascendente. Como es un
    // array podemos poner tantos criterios como a mi me de la gana JARRLL.
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.name
                                                              ascending:YES]],
    [NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.modificationDate
                                  ascending:NO];
    
    // NOTA: mejor que esto lo haga Core Data
    // Le decimos el limite de notas que queremos
    // Que nos muestre las diez primeras notas.
    //request.fetchLimit = 10;
    
    // Damelas en grupos de 10 en 10
    //request.fetchBatchSize = 10;
    
    
    // Para ejecutar la búsqueda hay que enviarle un mensaje al contexto
    // es un mensaje que nos devuelve un array y recibe un NSError por referencia
    NSError *error = nil;
    NSArray *results = [self.model.context executeFetchRequest:request
                                                         error:&error];
    
    if(results == nil){
        
        NSLog(@"Error al buscar: %@", results);
    }else{
        NSLog(@"Results %@", results);
    }
    
    // Eliminamos
    [self.model.context deleteObject:pampita];
    // Guardo
    [self save];
}

-(void)save{
    
    [self.model saveWithErrorBlock:^(NSError *error) {
        NSLog(@"Error al guardar %s \n\n %@", __func__, error);
    }];
}

-(void)autoSave{
    
    if (AUTO_SAVE){
        
        NSLog(@"Autoguardando...");
        
        // Guardo
        [self save];
        
        // Se ejecuta el código pasado 'AUTO_SAVE_DELAY_IN_SECONDS'
        // Llamada recursiva con retraso
        [self performSelector:@selector(autoSave)
                   withObject:nil
                   afterDelay:AUTO_SAVE_DELAY_IN_SECONDS];
    }
}












@end

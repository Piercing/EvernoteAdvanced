//
//  MGCNotesTableViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 3/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCNotesTableViewController.h"
#import "MGCNotebook.h"
#import "MGCNote.h"

@interface MGCNotesTableViewController ()
// Propiedad para guardar el modelo => en este caso la libreta.
@property (nonatomic, strong) MGCNotebook *model;
@end

@implementation MGCNotesTableViewController

#pragma mark - Init Methods
// Inicalizador designado
-(id) initWithNotebook:(MGCNotebook *)notebook{
    
    // Primero cero el fetched requests y un predicate y lo ordeno por nombre y creciente.
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[MGCNote entityName]];
    // La propiedad 'notebook' debe de ser igual a la que me han pasado como parámetro.
    req.predicate = [NSPredicate predicateWithFormat:@"notebook == %@", notebook];
    // Para poder meter un 'sortDescriptors' dentro de un 'fetchedResultsController' tiene que ir ordenado.
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:MGCNamedEntityAttributes.name
                                                          ascending:YES]];
    // Creo el fetched Results, nos pide el contexto pero no lo hemos pasado como parámetro.
    // No pasa nada myfrend, porque todo objeto de Core Data sabe en que 'manageObjectContext' está.
    // Para ello se lo pedimos al 'notebook' y 'pa lante como los de Alicante'.
    NSFetchedResultsController *fetched = [[NSFetchedResultsController alloc] initWithFetchRequest:req
                                                                              managedObjectContext:notebook.managedObjectContext
                                                                                sectionNameKeyPath:nil
                                                                                         cacheName:nil];
    // Una vez tengo el 'fetchedResultsController' se lo paso al inicializador que he heredado
    //  =>  'initWithFetchedResultsController' el 'fetched' que he creado y el estilo de la tabla.
    if (self = [super initWithFetchedResultsController:fetched
                                                 style:UITableViewStylePlain]) {
        // Si todo sale bien guardo las propiedades
        self.fetchedResultsController = fetched;
        self.model = notebook;
        self.title = notebook.name;
    }
    return self;
}

#pragma mark - data source
//
-(UITableViewCell *) tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Averiguo el objeto => nota
    MGCNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Creo una celda de sistema, no personalizada
    static NSString *cellId = @"NoteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    // La sincronizo, cojo el nombre de la nota => la pongo en la celda.
    cell.textLabel.text = note.name;
    
    return cell;
}

@end

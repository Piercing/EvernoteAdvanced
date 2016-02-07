//
//  MGCNotesViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 5/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCNotesViewController.h"
#import "MGCNote.h"
#import "MGCNoteCellView.h"
#import "MGCPhoto.h"
#import "MGCNoteViewController.h"
#import "MGCNotebook.h"
// Constante para el identificador de la
// celda y posteriormente poder registrarla.
static NSString *cellId = @"NoteCellId";

@interface MGCNotesViewController ()

@end

@implementation MGCNotesViewController

#pragma mark - View Lyfecicle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Llamo al Nib
    [self registerNib];
    // Asigno título a la celda
    self.title = @"Notas";
    // Asigno color a la celda (Xib)
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
    
    // Creo un botón para añadir nuevas notas en una libreta
    UIBarButtonItem *addBotton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                              target:self
                                                                              action:@selector(addNewNote:)];
    
    // Lo añado a la UI
    self.navigationItem.rightBarButtonItem = addBotton;
}

#pragma mark - Xib registration
-(void)registerNib{
    
    
    // Creo un Nib
    UINib *nib = [UINib nibWithNibName:@"MGCNoteCollectionViewCell"
                                bundle:nil];
    
    // Registro el Nib
    [self.collectionView registerNib:nib
          forCellWithReuseIdentifier:cellId];
}


// Tengo que implementar el método que devuelve la celda y registrar
// la celda adecuada. Del resto se encargará nuestra superclase.
#pragma mark - Data Source
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView
                cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // Obtengo el objeto => nota
    MGCNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Obtener una celda, lo hace la collectionView por nosotros si tenemos registrado el XIB
    MGCNoteCellView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                                      forIndexPath:indexPath];
    
    // La propia vista se encarga de obsrvar la nota y reflejar los cambios
    [cell observeNote:note];
    
    // Devolver la celda
    return cell;
}

#pragma mark - Delegate
-(void) collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // Obtengo el objeto => nota, a través del fetched Results Controller
    MGCNote *note = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear el controlador
    MGCNoteViewController *noteVC = [[MGCNoteViewController alloc]initWithModel:note];
    
    // Hacer un push
    [self.navigationController pushViewController:noteVC
                                         animated:YES];
}

#pragma mark - Utils
-(void)addNewNote:(id) sender{
    
    // Creo una instancia de MGCNoteViewController con el nuevo inicializador
    // y le paso la libreta a la que pertenece, que será la del 'indexPath',
    // es decir, la que pulso el usuario y dentro de ésta está creando una nueva nota.
    MGCNoteViewController *newNoteVC = [[MGCNoteViewController alloc]initForNewNoteInNotebook:self.notebook];
    
    // Hago un push
    [self.navigationController pushViewController:newNoteVC animated:YES];
}



@end

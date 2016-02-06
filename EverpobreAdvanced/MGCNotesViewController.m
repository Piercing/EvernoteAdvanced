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
    // Asigno color a la celda (Xib)
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.85
                                                            alpha:1];
    self.title = @"Notas";
    
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


@end

//
//  MGCCoreDataTableTableViewController.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 28/1/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>



// Heredamos de este controlador en vez de UITableViewController, reduciendo nuestro trabajo
@interface MGCCoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void)performFetch;

@property(nonatomic) BOOL suspendAutomaticTrackingOfChangesInManagedObjectContext;
@property BOOL debug;



// Nuestro propio inicializador que recibe el 'Fetch Controller' y el 'style'
// 'NSFetchedResultsController' => responde a todas la preguntas
//  de la tabla que antes teníamos que ir respondiendo manualmente.
-(id)initWithFetchedResultsController: (NSFetchedResultsController *) aFetchResultsController
                               style: (UITableViewStyle) aStyle;




@end

//
//  AGTCoreDataCollectionViewController.h
//  CoreDataTest
//
//  Created by MacBook Pro on 28/1/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//  Forked form Ash Furrows AFMasterViewController
//  https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController
//

@import Foundation;
@import CoreData;
@import UIKit;

@interface MGCCoreDataCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *detailViewControllerClassName;

+(instancetype) coreDataCollectionViewControllerWithFetchedResultsController:(NSFetchedResultsController *) resultsController
                                                                      layout:(UICollectionViewLayout*) layout;

-(id) initWithFetchedResultsController:(NSFetchedResultsController *) resultsController
                                layout:(UICollectionViewLayout*) layout;


@end

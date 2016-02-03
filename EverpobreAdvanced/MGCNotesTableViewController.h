//
//  MGCNotesTableViewController.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 3/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCCoreDataTableViewController.h"
@class MGCNotebook;

@interface MGCNotesTableViewController : MGCCoreDataTableViewController

-(id) initWithNotebook: (MGCNotebook *)notebook;

@end

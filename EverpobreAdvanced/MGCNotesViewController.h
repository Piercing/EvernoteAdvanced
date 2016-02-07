//
//  MGCNotesViewController.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 5/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCCoreDataCollectionViewController.h"
@class MGCNotebook;

@interface MGCNotesViewController : MGCCoreDataCollectionViewController
// Añado una nueva propiedad de tipo libreta que nos hará falta
@property(nonatomic, strong) MGCNotebook* notebook;
@end

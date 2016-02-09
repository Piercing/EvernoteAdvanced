//
//  MGCLocationViewController.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 9/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MGCLocation.h"


@interface MGCLocationViewController : UIViewController
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)standarMap:(id)sender;
- (IBAction)satelliteMap:(id)sender;
- (IBAction)hybridMap:(id)sender;

// Inicializador
-(id)initWithLocation:(MGCLocation *) location;

@end

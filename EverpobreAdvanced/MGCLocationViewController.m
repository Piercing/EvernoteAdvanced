//
//  MGCLocationViewController.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 9/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCLocationViewController.h"
#import "MGCLocation.h"

@interface MGCLocationViewController ()<MKMapViewDelegate>
@property(nonatomic,strong) MGCLocation *model;
@end

@implementation MGCLocationViewController

-(id)initWithLocation:(MGCLocation *) location{
    
    if(self = [super initWithNibName:nil
                              bundle:nil]){
        
        _model = location;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Le paso la anotación a la mapView
    [self.mapView addAnnotation:self.model];
    
    // Asigno región inicial
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 2000000, 2000000);
    [self.mapView setRegion:region];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Cambio la región con animación
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(self.model.coordinate, 500, 500);
    
    // Lo aplico después de un retraso
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.mapView setRegion:region
                       animated:YES];
    });
    
}
#pragma mark - Actions

- (IBAction)standarMap:(id)sender {
    self.mapView.mapType = MKMapTypeStandard;
}

- (IBAction)satelliteMap:(id)sender {
    self.mapView.mapType = MKMapTypeSatellite;
}

- (IBAction)hybridMap:(id)sender {
    self.mapView.mapType = MKMapTypeHybrid;
}



#pragma mark - MKMapViewDelegate

@end

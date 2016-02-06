//
//  MGCNoteViewController.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 6/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MapKit;

@class MGCNote;
@interface MGCNoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *modificationDateView;
@property (weak, nonatomic) IBOutlet UILabel *nameView;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextView *textView;


// Inicializador
-(id) initWithModel:(MGCNote *)model;

@end

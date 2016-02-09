#import "_MGCLocation.h"
#import <MapKit/MapKit.h>
@import CoreLocation;

@class MGCNote;

@interface MGCLocation : _MGCLocation <MKAnnotation> {}
// Custom logic goes here.

#pragma mark - Class Methods
+(instancetype) locationWithCLLocation:(CLLocation *)location
                               forNote:(MGCNote *)note;
@end

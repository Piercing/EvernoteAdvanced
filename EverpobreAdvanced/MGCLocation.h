#import "_MGCLocation.h"

@import CoreLocation;
@class MGCNote;

@interface MGCLocation : _MGCLocation {}
// Custom logic goes here.

#pragma mark - Class Methods
+(instancetype) locationWithCLLocation:(CLLocation *)location
                               forNote:(MGCNote *)note;
@end

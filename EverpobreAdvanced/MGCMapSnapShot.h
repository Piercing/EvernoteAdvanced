#import "_MGCMapSnapShot.h"
#import <UIKit/UIKit.h>

@interface MGCMapSnapShot : _MGCMapSnapShot {}

// Propiedad de conveniencia
@property (nonatomic, strong) UIImage *image;

// Necesito un método factory
+(instancetype) mapSnapShotForLocation:(MGCLocation *) location;
@end

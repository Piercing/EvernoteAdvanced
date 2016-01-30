#import "_MGCPhoto.h"
@import UIKit;

@interface MGCPhoto : _MGCPhoto {}

// Creamos una propiedad para la imagen para trabajar con UIImage y no con NSData
@property (nonatomic, strong)UIImage *image;

+(instancetype) photoWithImage:(UIImage *) image
                      context:(NSManagedObjectContext *)context;

@end

//
//  MGCPhotoViewController.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 7/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGCDetailViewController.h"

@interface MGCPhotoViewController : UIViewController<MGCDetailViewController>
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
- (IBAction)takePhoto:(id)sender;
- (IBAction)deletePhoto:(id)sender;
- (IBAction)applyVintageEffect:(id)sender;

@end

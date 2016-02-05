//
//  MGCNoteCellView.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 5/2/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGCNoteCellView : UICollectionViewCell

@property(weak, nonatomic)IBOutlet UIImageView *photoView;
@property(weak, nonatomic)IBOutlet UILabel *modificationDateView;
@property(weak, nonatomic)IBOutlet UILabel *titleView;


@end

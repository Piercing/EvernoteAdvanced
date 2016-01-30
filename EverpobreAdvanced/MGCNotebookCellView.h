//
//  MGCNotebookCellView.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 29/1/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGCNotebookCellView : UITableViewCell

@property (nonatomic, weak)IBOutlet UILabel *nameView;
@property (nonatomic, weak)IBOutlet UILabel *numberOfNotesView;

// Creamos el método de clase que devuelve una cadena
+(NSString *)cellId;
+(CGFloat)cellHeight;

@end

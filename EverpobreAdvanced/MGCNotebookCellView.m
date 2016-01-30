//
//  MGCNotebookCellView.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 29/1/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "MGCNotebookCellView.h"

@implementation MGCNotebookCellView

#pragma mark - Class Methods
// Personalizo la celda con estos dos métodos de clase

+(NSString *)cellId{
    // El identificador de la celda va a ser el nombre de la clase.
    // 'NSStringFromClass'=> devuelve una cadena a partir de la clase.
    // Como estamos en un método de clase (+), nos devolvera la clase.
    return  NSStringFromClass(self);
}
// Altura de la celda, le dimos => 60, al crearla en el XIB.
+(CGFloat)cellHeight{
    return 60.0f;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

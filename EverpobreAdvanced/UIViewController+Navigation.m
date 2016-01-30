//
//  UIViewController+Navigation.m
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 29/1/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

// Creo un 'navigationController' me meto a mi mismo (self) y devuelvo ese navigationController
-(UINavigationController *)wrappedInNavigation{
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self];
    
    return nav;
}

@end

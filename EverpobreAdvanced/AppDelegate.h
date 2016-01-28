//
//  AppDelegate.h
//  EverpobreAdvanced
//
//  Created by MacBook Pro on 26/1/16.
//  Copyright © 2016 weblogmerlos.com. All rights reserved.
//

#import <UIKit/UIKit.h>

// forward declaration
@class AGTSimpleCoreDataStack;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) AGTSimpleCoreDataStack * model;

@end


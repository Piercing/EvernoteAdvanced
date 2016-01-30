//
//  AGTSimpleCoreDataStack.h
//  everpobre
//
//  Created by Fernando Rodríguez Romero on 12/12/13.
//  Copyright (c) 2013 Agbo. All rights reserved.
//

// Explicación de @import:
// http://www.cocoaosx.com/2013/10/07/import-modules-modules-objectivec/
@import CoreData;

#import <Foundation/Foundation.h>

@interface AGTSimpleCoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSManagedObjectContext *context;

+ (NSString *)persistentStoreCoordinatorErrorNotificationName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName
                          databaseFilename:(NSString *)aDBName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName;

+ (instancetype)coreDataStackWithModelName:(NSString *)aModelName
                               databaseURL:(NSURL *)aDBURL;

- (id)initWithModelName:(NSString *)aModelName databaseURL:(NSURL *)aDBURL;

- (void)zapAllData;

- (void)saveWithErrorBlock:(void(^)(NSError *error))errorBlock;
-(NSArray *)executeRequest:(NSFetchRequest *)request
                 withError:(void(^)(NSError *error))errorBlock;
@end

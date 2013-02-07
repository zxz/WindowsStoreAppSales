//
//  AppDelegate.m
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "AppDelegate.h"
#import "RecordManager.h"

@implementation AppDelegate

@synthesize managedObjectModel=_managedObjectModel, managedObjectContext=_managedObjectContext, persistentStoreCoordinator=_persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    // Override point for customization after application launch.
//    UIViewController *viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
//    UIViewController *viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
//    self.tabBarController = [[UITabBarController alloc] init];
//    self.tabBarController.viewControllers = @[viewController1, viewController2];
    [[RecordManager sharedInstance]setPsc:[self persistentStoreCoordinator]];
    self.saleViewController=[[SalesViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:self.saleViewController];
    self.saleViewController.managedObjectContext=[self managedObjectContext];
    self.window.rootViewController=nav;
    
//    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}
- (void)saveContext
{
    NSError *error;
    if (_managedObjectContext != nil) {
        if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            return;
        }
    }
}

#pragma mark -
#pragma mark Core Data stack

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return _managedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Sale" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"sale.sqlite"];
    //    NSLog(@"path=%@",storeURL.debugDescription);
    
    /*
     Set up the store.
     For the sake of illustration, provide a pre-populated default store.
     */
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"sale" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        return nil;
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark -
#pragma mark Application's documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end

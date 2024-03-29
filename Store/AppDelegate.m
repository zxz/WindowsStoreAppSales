//
//  AppDelegate.m
//  Store
//
//  Created by 鄒 西中 on 2/7/13.
//  Copyright (c) 2013 鄒 西中. All rights reserved.
//

#import "AppDelegate.h"
#import "RecordManager.h"
#import "DailyViewController.h"
#import "WebBrowser.h"
#import "CurrencyManager.h"
#import "ReviewViewController.h"
#import "ReviewManager.h"
#import "Util.h"
#import "NSString+url.h"
@implementation AppDelegate

@synthesize managedObjectModel=_managedObjectModel, managedObjectContext=_managedObjectContext, persistentStoreCoordinator=_persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"MyDatabase.sqlite"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    NSString *currencyCode = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
	if (![[CurrencyManager sharedManager].availableCurrencies containsObject:currencyCode]) {
		currencyCode = @"JPY";
	}
	NSDictionary *defaults = [NSDictionary dictionaryWithObjectsAndKeys:
							  currencyCode, @"CurrencyManagerBaseCurrency",
							  nil];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    self.tabBarController = [[UITabBarController alloc] init];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:[[SalesViewController alloc]initWithStyle:UITableViewStyleGrouped]];
    nav.navigationBar.barStyle=UIBarStyleBlack;
    nav.title=@"Daily Report";
    WebBrowser *browser = [[WebBrowser alloc]initWithNibName:@"WebBrowser" bundle:nil];
    
    UINavigationController *navReview=[[UINavigationController alloc]initWithRootViewController:[[ReviewViewController alloc]initWithStyle:UITableViewStyleGrouped]];
    navReview.navigationBar.barStyle=UIBarStyleBlack;
    navReview.title=@"Review";
    
    self.tabBarController.viewControllers = @[[[DailyViewController alloc]initWithStyle:UITableViewStyleGrouped], nav,navReview, browser];
    
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [MagicalRecord cleanUp];
    
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

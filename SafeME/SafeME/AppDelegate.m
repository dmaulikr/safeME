//
//  AppDelegate.m
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import "AppDelegate.h"
#import "ChannelsTableViewController.h"
#import "SignInViewController.h"
#import "MapViewController.h"

#import <Parse/Parse.h>
#import <Bolts/Bolts.h>
@interface AppDelegate ()

@end

NSNumber *stageOfFoodChannel = 0;
DriveStage stageOfDriveChannel = 0;
NSNumber *stageOfMovieChannel = 0;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    self.navController = [[UINavigationController alloc]init];
    
    self.window.rootViewController = self.navController;
    MapViewController *mapVC = [MapViewController new];
    [self.navController pushViewController:mapVC animated:YES];
//    SignInViewController *viewController = [[SignInViewController alloc]init];
//    [self.navController pushViewController:viewController animated:TRUE];
//    viewController.managedObjectContext = self.driveManagedObjectContext;
//    ChannelsTableViewController *viewController = [[ChannelsTableViewController alloc]init];
//    [self.navController pushViewController:viewController animated:TRUE];
//    viewController.driveManagedObjectContext = self.driveManagedObjectContext;

    [QBApplication sharedApplication].applicationId = 21391;
    [QBConnection registerServiceKey:@"FuP4KDyMGkWFDc2"];
    [QBConnection registerServiceSecret:@"HJDRGxVSd8wySka"];
    [QBSettings setAccountKey:@"HJDRGxVSd8wySka"];
    
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"A9uhdUlFKztUKQIKiUFevJtbvBpICFsBaRtkWZaG"
                  clientKey:@"AprabGgqUDe5XsfPX6abmucdIdZv97JAP2s1ZK1l"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    return YES;
}
- (NSManagedObjectContext *)driveManagedObjectContext{
    if (_driveManagedObjectContext != nil) {
        return _driveManagedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _driveManagedObjectContext = [[NSManagedObjectContext alloc] init];
        [_driveManagedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _driveManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataModel.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    NSLog(@"PersistentStoreCoordinator created");

    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

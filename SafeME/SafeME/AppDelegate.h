//
//  AppDelegate.h
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <QuickBlox/QuickBlox.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property(strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property(strong, nonatomic) NSManagedObjectContext *driveManagedObjectContext;
@property(strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//+(NSManagedObjectContext*)managedObjectContext;
typedef NS_ENUM(NSUInteger, DriveStage) {
    Initial,
    Ride,
    Personal,
    Share,
    Destination,
    RideNow,
    RideLater,
    ShareConfirm,
};

extern DriveStage stageOfDriveChannel;
@end


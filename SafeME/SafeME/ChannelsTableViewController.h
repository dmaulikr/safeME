//
//  ChannelsTableViewController.h
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//NSString* const kTravel = @"Travel";

@interface ChannelsTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *channels;
@property(strong, nonatomic) NSManagedObjectContext *driveManagedObjectContext;

typedef NS_ENUM(NSUInteger, Channel) {
    DriveChannel,
    FoodChannel,
    MovieChannel,
};

@end


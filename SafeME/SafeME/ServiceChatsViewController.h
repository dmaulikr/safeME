//
//  ServiceChatsViewController.h
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ChannelsTableViewController.h"

@interface ServiceChatsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate
, UITextFieldDelegate , NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) IBOutlet UITextField *messageTextField;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property(strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *corider;
@property Channel channel;

- (instancetype)initWithChannel:(Channel)channel;

@end

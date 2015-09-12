//
//  ServiceChatsViewController.m
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import "ServiceChatsViewController.h"
#import "ChatDialogViewCell.h"
#import "Message.h"
#import "AppDelegate.h"
#import "WYPopoverController.h"
#import "MapViewController.h"
@interface ServiceChatsViewController () < WYPopoverControllerDelegate ,MapViewDelegate>

@end
WYPopoverController *popOver;
NSString *destination = @"Whitefield";
BOOL keyboardIsShown = NO;
@implementation ServiceChatsViewController

- (instancetype)initWithChannel:(Channel)channel
{
    self = [super init];
    if (self) {
        self.channel = channel;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.view addSubview:self.tableview];
    self.messageTextField.delegate = self;
    self.navigationItem.title = @"Travel";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:70/255.f green:135/255.f blue:256/255.f alpha:1.0]}];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:self.view.window];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:self.view.window];
    keyboardIsShown = NO;
//    //make contentSize bigger than your scrollSize (you will need to figure out for your own use case)
//    CGSize scrollContentSize = CGSizeMake(320, 345);
//    self.scrollView.contentSize = scrollContentSize;

    [self scrollToBottom];

}
- (void)keyboardWillHide:(NSNotification *)n
{
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    // resize the scrollview
    CGRect viewFrame = self.view.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height += (keyboardSize.height);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    keyboardIsShown = NO;
}

- (void)keyboardWillShow:(NSNotification *)n
{
    // This is an ivar I'm using to ensure that we do not do the frame size adjustment on the `UIScrollView` if the keyboard is already shown.  This can happen if the user, after fixing editing a `UITextField`, scrolls the resized `UIScrollView` to another `UITextField` and attempts to edit the next `UITextField`.  If we were to resize the `UIScrollView` again, it would be disastrous.  NOTE: The keyboard notification will fire even when the keyboard is already shown.
    if (keyboardIsShown) {
        return;
    }
    
    NSDictionary* userInfo = [n userInfo];
    
    // get the size of the keyboard
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // resize the noteView
    CGRect viewFrame = self.view.frame;
    // I'm also subtracting a constant kTabBarHeight because my UIScrollView was offset by the UITabBar so really only the portion of the keyboard that is leftover pass the UITabBar is obscuring my UIScrollView.
    viewFrame.size.height -= (keyboardSize.height );
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    keyboardIsShown = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatDialogViewCell *cell;
    cell = [self.tableview dequeueReusableCellWithIdentifier:@"dialogCellId"];
    if (!cell) {
        cell = [[ChatDialogViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dialogCellId"];
    }
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSArray *chats = [sectionInfo objects];

    [cell configureCellWithMessage:chats[indexPath.row]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:indexPath.section];
    NSArray *chats = [sectionInfo objects];
    return [ChatDialogViewCell heightForCellWithMessage:chats[indexPath.row]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendMessage];
    return YES;
}
- (IBAction)sendTapped:(id)sender
{
    [self sendMessage];
}
-(void)didConfirm:(NSString*)corider
{
    self.corider = corider;
    [popOver dismissPopoverAnimated:YES];
    stageOfDriveChannel = ShareConfirm;
    [self getReplyForStage:stageOfDriveChannel];
}
-(void)didConfirm
{
    [popOver dismissPopoverAnimated:YES];
    stageOfDriveChannel = ShareConfirm;
    [self getReplyForStage:stageOfDriveChannel];
}
- (void)sendMessage
{
    if(self.messageTextField.text.length > 0 ){
        if (self.channel == DriveChannel) {
            Message *message = [Message messageWithText:self.messageTextField.text inContext:self.managedObjectContext];
            message.isReply = [NSNumber numberWithBool:NO];
            message.channelType = @"DriveChannel";
            if ([self containsCabKeyword:message.text] || (stageOfDriveChannel == Initial && [self containsYesKeyword:message.text])) {
                stageOfDriveChannel = Ride;
            }
            else if (stageOfDriveChannel == Ride && [self containsLaterKeyword:message.text]) {
                stageOfDriveChannel = RideLater;
            }
           else if (stageOfDriveChannel == Ride && [self containsNowKeyword:message.text]){
                stageOfDriveChannel = RideNow;
            }
            else if (stageOfDriveChannel == RideNow && [self containsYesKeyword:message.text]) {
                stageOfDriveChannel = Share;
            }
            else if (stageOfDriveChannel == RideNow) {
                stageOfDriveChannel = Personal;
            }
            else if (stageOfDriveChannel == Share) {
                destination = self.messageTextField.text;
                stageOfDriveChannel = Destination;
            }
            else if (stageOfDriveChannel == Destination) {
                destination = self.messageTextField.text;
                stageOfDriveChannel = Destination;
            }
            else{
                stageOfDriveChannel = Initial;
            }
            [self getReplyForStage:stageOfDriveChannel];
            
        }
        [self scrollToBottom];
    }
    self.messageTextField.text = nil;
}
- (void)getReplyForStage:(DriveStage)stage
{
    if (self.channel == DriveChannel) {
        if (stage == Initial) {
            Message *reply = [Message messageWithText:@"Hey there!!" inContext:self.managedObjectContext];
            reply.isReply = [NSNumber numberWithBool:YES];
            reply.channelType = @"DriveChannel";
            Message *reply2 = [Message messageWithText:@"Would you like to book a cab?" inContext:self.managedObjectContext];
            reply2.isReply = [NSNumber numberWithBool:YES];
            reply2.channelType = @"DriveChannel";
            
        }
        if (stage == Ride) {
            Message *reply = [Message messageWithText:@"Would you like to ride now or later ?" inContext:self.managedObjectContext];
            reply.isReply = [NSNumber numberWithBool:YES];
            reply.channelType = @"DriveChannel";
            
        }
        if (stage == RideNow) {
            Message *reply = [Message messageWithText:@"Are you willing to share?" inContext:self.managedObjectContext];
            reply.isReply = [NSNumber numberWithBool:YES];
            reply.channelType = @"DriveChannel";
            
        }
        if (stage == Personal) {
            Message *reply = [Message messageWithText:@"Your personal cab is booked \nDriver:Mr.Shibu\n 9876543210\nWhite Toyota Indica\nKA 51B 3633" inContext:self.managedObjectContext];
            reply.isReply = [NSNumber numberWithBool:YES];
            reply.channelType = @"DriveChannel";
            Message *reply2 = [Message messageWithText:@"Enjoy your ride :)" inContext:self.managedObjectContext];
            reply2.isReply = [NSNumber numberWithBool:YES];
            reply2.channelType = @"DriveChannel";
        }
        if (stage == Share) {
            Message *reply = [Message messageWithText:@"Where do you want to go?" inContext:self.managedObjectContext];
            reply.isReply = [NSNumber numberWithBool:YES];
            reply.channelType = @"DriveChannel";
         }
        if (stage == Destination) {
            [self mapPopOver];
        }
        if (stage == ShareConfirm) {
            Message *reply = [Message messageWithText:@"Your cab is booked \nDriver:Mr.Krishnappa\n 9876543210\nSilver Tata Indica\nKA 03 AB 4236" inContext:self.managedObjectContext];
            reply.isReply = [NSNumber numberWithBool:YES];
            reply.channelType = @"DriveChannel";
//            Message *reply2 = [Message messageWithText:[NSString stringWithFormat:@"You'll be sharing it with %@",self.corider]  inContext:self.managedObjectContext];
            Message *reply2 = [Message messageWithText:[NSString stringWithFormat:@"You'll be sharing it with a co-passenger"]  inContext:self.managedObjectContext];
            reply2.isReply = [NSNumber numberWithBool:YES];
            reply2.channelType = @"DriveChannel";
            Message *reply3 = [Message messageWithText:@"Enjoy your ride :)" inContext:self.managedObjectContext];
            reply3.isReply = [NSNumber numberWithBool:YES];
            reply3.channelType = @"DriveChannel";
        }
        if (stage == RideLater) {
            Message *reply = [Message messageWithText:@"See you later :)" inContext:self.managedObjectContext];
            reply.isReply = [NSNumber numberWithBool:YES];
            reply.channelType = @"DriveChannel";
        }

   }
}
- (void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self saveContext];
   
}
-(void)mapPopOver
{
    [self.messageTextField resignFirstResponder];
    MapViewController *mapView =[[MapViewController alloc]init];
    popOver = [[WYPopoverController alloc] initWithContentViewController:mapView];
    popOver.delegate = self;
    mapView.delegate = self;
    mapView.destination = destination;
    popOver.popoverContentSize = CGSizeMake(300, 400);
    [popOver presentPopoverAsDialogAnimated:YES];
}

-(void)scrollToBottom
{
    NSError *error = nil;
    
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    NSUInteger sectionIndex = [[self.fetchedResultsController sections] count];
    if (sectionIndex) {
        id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:sectionIndex - 1];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:[sectionInfo numberOfObjects]-1 inSection:sectionIndex - 1];
        [self.tableview scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    }
}
#pragma mark - helpers

-(BOOL)containsCabKeyword:(NSString*)message
{
    if ([message containsString:@"cab"] || [message containsString:@"ride"] ||
        [message containsString:@"travel"] || [message containsString:@"taxi"] ) {
        return YES;
    }
    return NO;
}
-(BOOL)containsYesKeyword:(NSString*)message
{
    if ([message containsString:@"yes"] || [message containsString:@"yea"] || [message containsString:@"yep"] || [message containsString:@"yup"]) {
        return YES;
    }
    return NO;
}
-(BOOL)containsNowKeyword:(NSString*)message
{
    if ([message containsString:@"now"] || [message containsString:@"right away"]) {
        return YES;
    }
    return NO;
}
-(BOOL)containsLaterKeyword:(NSString*)message
{
    if ([message containsString:@"later"] || [message containsString:@"not now"] || [message containsString:@"after a while"]) {
        return YES;
    }
    return NO;
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Message"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES]];
//    NSPredicate *channelPredicate = [NSPredicate predicateWithFormat:@"'channelType' like 'DriveChannel'"];
//    request.predicate = channelPredicate;
    _fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"time" cacheName:nil];
    _fetchedResultsController.delegate = self;
    return _fetchedResultsController;
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.tableview reloadData];
    [self scrollToBottom];
}
@end

//
//  Message.m
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import "Message.h"
#import "AppDelegate.h"

@implementation Message

@synthesize isReply;
@synthesize text;
@synthesize time;
@synthesize channelType;
NSString* const kMessage = @"Message";

- (instancetype)initWithText:(NSString*)messageText
{
    self = [super init];
    if (self) {
        self.text = messageText;
        self.time = [NSDate date];
    }
    return self;
}

+(Message*)messageWithText:(NSString *)text inContext:(NSManagedObjectContext*)context
{
    Message *message = [NSEntityDescription insertNewObjectForEntityForName:kMessage inManagedObjectContext:context];
    message.text = text;
    message.time = [NSDate date];
    
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = context;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }

    return message;
}
@end

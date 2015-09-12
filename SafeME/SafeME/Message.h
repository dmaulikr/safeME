//
//  Message.h
//  Kaizen
//
//  Created by Ponnie Rohith on 28/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface Message : NSManagedObject
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *channelType;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, strong) NSNumber *isReply;

+(Message*)messageWithText:(NSString *)text inContext:(NSManagedObjectContext*)context;
@end

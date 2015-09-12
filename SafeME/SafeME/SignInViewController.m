//
//  SignInViewController.m
//  Kaizen
//
//  Created by Ponnie Rohith on 29/03/15.
//  Copyright (c) 2015 PR. All rights reserved.
//

#import "SignInViewController.h"

@interface SignInViewController () <QBChatDelegate>

@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createSession];

}
-(void)createSession
{
    NSString *userLogin = @"igorquickblox";
    NSString *userPassword = @"igorquickblox";
    
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = userLogin;
    parameters.userPassword = userPassword;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        // Sign In to QuickBlox Chat
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID; // your current user's ID
        currentUser.password = userPassword; // your current user's password
        
        // set Chat delegate
        [[QBChat instance] addDelegate:self];
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];
        
    } errorBlock:^(QBResponse *response) {
        // error handling
        NSLog(@"error: %@", response.error);
    }];
    
}
#pragma mark QBChatDelegate

// Chat delegate
-(void) chatDidLogin
{
    // You have successfully signed in to QuickBlox Chat
    NSLog(@"chatDidLogin");
}

- (void)chatDidNotLogin
{
    NSLog(@"chatDidNotLogin");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // Create session with user

}


@end

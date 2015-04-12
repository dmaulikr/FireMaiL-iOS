//
//  FMLoginController.m
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import "FMLoginController.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "FMConstants.h"
#import "FMCommunicator.h"
#import "FMMainViewController.h"
#import "FMUser.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@implementation FMLoginController{
    CGRect screen;
    UIImageView* logo;
    UILabel* welcomeLogin;
    UILabel* loading;
    
    NSString* capture;
    NSString* accessToken;
    
    FMUser* mainUserObject;
    
    FMMainViewController* main;
    BOOL isAppLaunch;
}

- (instancetype)initWithEmptyUser:(FMUser*)user{
    mainUserObject = user;
    return self;
}

- (void)viewDidLoad{
    screen = [[UIScreen mainScreen] bounds];
    isAppLaunch = YES;
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.shouldFetchGoogleUserID = YES;
    //signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email
    
    // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    
    // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin, @"https://mail.google.com/", @"https://www.googleapis.com/auth/gmail.readonly"];  // "https://www.googleapis.com/auth/plus.login" scope
    //signIn.scopes = @[ @"profile" ];            // "profile" scope
    
    [signIn.authentication setScope:@"https://mail.google.com/"];
    
    // Optional: declare signIn.actions, see "app activities"
    signIn.delegate = self;
    
    _signInButton = [[GPPSignInButton alloc] initWithFrame:CGRectMake(screen.size.width/2-75, screen.size.height/2+130, 100, 60)];
    [_signInButton setAlpha:0.0];
    [_signInButton setUserInteractionEnabled:NO];
    [self.view addSubview:_signInButton];
    
    welcomeLogin = [[UILabel alloc] initWithFrame:CGRectMake(0, _signInButton.frame.origin.y-80, screen.size.width, 80)];
    [welcomeLogin setNumberOfLines:2];
    [welcomeLogin setTextAlignment:NSTextAlignmentCenter];
    [welcomeLogin setText:@"Welcome to FireMaiL! \n Please Log In To Continue!"];
    [welcomeLogin setAlpha:0.0];
    [self.view addSubview:welcomeLogin];
    
    loading = [[UILabel alloc] initWithFrame:CGRectMake(0, _signInButton.frame.origin.y-200, screen.size.width, 80)];
    [loading setNumberOfLines:2];
    [loading setTextAlignment:NSTextAlignmentCenter];
    [loading setText:@"loading your email \n Please Wait"];
    [loading setAlpha:0.0];
    [self.view addSubview:loading];
    
    logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"m.png"]];
    [logo setFrame:CGRectMake(screen.size.width/2-90, welcomeLogin.frame.origin.y-85, 180, 110)];
    [logo setAlpha:0.0];
    [self.view addSubview:logo];
    
    NSLog(@"starting animation attempt!");
    [UIView animateWithDuration:0.6 animations:^{
        //stage one animation
        [logo setAlpha:1.0];
        logo.frame = CGRectOffset( logo.frame, 0, -130 ); // offset by an amount
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.6 animations:^{
            //stage two animation
            [welcomeLogin setAlpha:1.0];
            welcomeLogin.frame = CGRectOffset( welcomeLogin.frame, 0, -130 ); // offset by an amount
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.6 animations:^{
                //stage three animation
                [_signInButton setAlpha:1.0];
                _signInButton.frame = CGRectOffset( _signInButton.frame, 0, -130 ); // offset by an amount
            } completion:^(BOOL finished) {
                //handle completion
                [_signInButton setUserInteractionEnabled:YES];
            }];
        }];
    }];
    
    
    
}


#pragma mark - GPPSignInDelegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error{
    
    
    NSLog(@"delegate called!");
    if (error) {
        //handle the problem
        NSLog(@"looks liek there was a problem: %@", error);
    } else {
        [UIView setAnimationsEnabled:YES];
        [UIView animateWithDuration:0.4 animations:^{
            [logo setAlpha:0.0];
            [welcomeLogin setAlpha:0.0];
            [_signInButton setAlpha:0.0];
            [loading setAlpha:1.0];
        } completion:^(BOOL finished) {
            //
        }];
        
        
        capture = [[GPPSignIn sharedInstance] userID];
        accessToken = [[[GPPSignIn sharedInstance] authentication] accessToken];
        
//        [[[GPPSignIn sharedInstance] authentication] tokenURL]
        
        NSString* temp = [[[GPPSignIn sharedInstance] authentication] code];
        
        NSLog(@"requisite information does include auth token: %@", temp);
        
        NSLog(@"got the requisite information: %@, and %@, and %@", capture, accessToken, [[[GPPSignIn sharedInstance] authentication] refreshToken]);
        
        mainUserObject = [[FMUser alloc] initWithGoogle];
        
        FMCommunicator* comm = [[FMCommunicator alloc] initWithManager];
        comm.delegate = self;
        
        [comm grabEmailForUser:mainUserObject];
    }
    
    
}

- (void)gotEmailForUser:(NSMutableArray *)arrayOfEmailObjects{
    
    
    NSLog(@"checking presence of email objects: %@", arrayOfEmailObjects);
    
    
    if (isAppLaunch == YES) { // done to provision for email handling afterwards.
        NSLog(@"launch is go");
        isAppLaunch = NO;
        main = [[FMMainViewController alloc] initWithEmails:arrayOfEmailObjects];
        [self presentViewController:main animated:YES completion:^{
            NSLog(@"entered the thanggggg");
        }];
//        [self.navigationController pushViewController:main animated:YES];
    }
}

@end

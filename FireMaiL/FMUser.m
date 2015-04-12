//
//  FMUser.m
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import "FMUser.h"
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@implementation FMUser

- (instancetype)initWithGoogle{
    
    self.userEmail = [[GPPSignIn sharedInstance] userEmail];
    
    self.userID = [[GPPSignIn sharedInstance] userID];
    
    self.netID = [NSString stringWithFormat:@""];
    
    self.accessToken = [[[GPPSignIn sharedInstance] authentication] accessToken];
    
    NSLog(@"successful nyu login: \n\t email:%@ \n\t user access token: %@ \n\t user ID: %@", self.userEmail, self.accessToken, self.userID);
    
    return self;
}

@end

//
//  FMCommunicator.m
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import "FMCommunicator.h"
#import "FMUser.h"
#import "FMDataBuilder.h"
#import "AFNetworking.h"
#import "FMConstants.h"
#import "FMEmail.h"

@implementation FMCommunicator{
    AFHTTPRequestOperationManager* manager;
    NSMutableArray* emailObjects;
    BOOL releaseFlag;
}

- (instancetype)initWithManager{
    manager = [AFHTTPRequestOperationManager manager];
    emailObjects = [[NSMutableArray alloc] init];
    return self;
}

- (void)grabEmailForUser:(FMUser*)user{
    
    NSString* url= [NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages?labelIds=INBOX&labelIds=UNREAD&maxResults=25&access_token=%@", user.userID, user.accessToken];
    
    NSLog(@"attempting to fetch message list for user with URL: %@", url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //handle success with delegate
        NSLog(@"received raw email stream: \n\n %@", responseObject);
        NSMutableDictionary* responseDict = responseObject;
        NSArray* raw = [responseDict objectForKey:@"messages"];
        NSMutableArray* emailArray = [[NSMutableArray alloc] init]; //temp
        
        for (int i = 0; i < [raw count]; ++i) {
            NSString* urlString = [NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages/%@?&access_token=%@", user.userID, [[raw objectAtIndex:i] objectForKey:@"id"], user.accessToken];
            [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                FMEmail* email = [self buildEmailFromData:responseObject];
                [emailObjects addObject:email];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error: %@", error);
            }];
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            releaseFlag = NO;
            int i = 0;
            while (i < 1000000000) {
                if (releaseFlag == NO) {
                    [self connectionRuntimeAlpha];
                    ++i;
                } else {
                    break;
                }
            }
        });
        
//        [self.delegate gotEmailForUser:emailArray];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"fetching failed with error: \n\n %@", error);
    }];

}

- (FMEmail*)buildEmailFromData:(NSMutableDictionary*)data{
    NSString* body = @"";
    NSString* title = @"";
    NSString* sender = @"";
    
    NSArray* headers = [[data objectForKey:@"payload"] objectForKey:@"headers"];
    for (id c in headers) {
        if ([[c objectForKey:@"name"] isEqualToString:@"Subject"]) {
            title = [c objectForKey:@"value"];
        } else if ([[c objectForKey:@"name"] isEqualToString:@"From"]){
            sender = [c objectForKey:@"value"];
        }
    }
    
    NSLog(@"title of email: %@", title);
    NSLog(@"sender for mail: %@", sender);
    
    if ([[[data objectForKey:@"payload"] objectForKey:@"mimeType"] isEqualToString:@"multipart/related"]) {
        //do something
        NSLog(@"discovered form one");
        
        body = [[[[[[[data objectForKey:@"payload"] objectForKey:@"parts"] objectAtIndex:0] objectForKey:@"parts"] objectAtIndex:0] objectForKey:@"body"] objectForKey:@"data"];
    } else if ([[[data objectForKey:@"payload"] objectForKey:@"mimeType"] isEqualToString:@"multipart/alternative"]) {
        NSLog(@"discovered form two");
        
        body = [[[[[data objectForKey:@"payload"] objectForKey:@"parts"] objectAtIndex:0] objectForKey:@"body"] objectForKey:@"data"];
        
        NSLog(@"form two body: \n %@", body);
    }
    
    
    if (![body isEqualToString:@""]) {
        NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:body options:0];
        NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
        body = decodedString;
        NSLog(@"decoded email body for individual resoponse: %@", decodedString);
        
        NSLog(@"body for key: %@", body);
    }
    
    NSString* insert = [NSString stringWithFormat:@"https://dregsweg.herokuapp.com/api/v1/shorten?title=%@&body=%@", title, body];
    
    NSURL* requestURL2 = [NSURL URLWithString:insert];
    NSURLRequest* request2 = [NSURLRequest requestWithURL:requestURL2];
    NSURLResponse* resp2 = nil;
    NSError* error2 = nil;
    
    NSData* shortResponse = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&resp2 error:&error2];
    
    NSLog(@"check: %@", shortResponse);
    
    //            NSMutableDictionary* response2 = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:request2 returningResponse:&resp2 error:&error2] options:NSJSONReadingAllowFragments error:nil];
    
        FMEmail* email = [[FMEmail alloc] initWithTitle:title andBody:body andSender:sender andSummary:nil];


    return email;
}
//jerry.hau@nyu.edu

- (void)connectionRuntimeAlpha{
    if ([emailObjects count] < 20) {
        
    } else {
        releaseFlag = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate gotEmailForUser:emailObjects];
        });
    }
}


@end

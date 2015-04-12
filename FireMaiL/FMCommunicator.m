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
}

- (instancetype)initWithManager{
    manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    return self;
}

- (void)grabEmailForUser:(FMUser*)user{
    
    NSString* url= [NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages?labelIds=INBOX&labelIds=UNREAD&maxResults=50&access_token=%@", user.userID, user.accessToken];
    
    NSLog(@"attempting to fetch message list for user with URL: %@", url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //handle success with delegate
        NSLog(@"received raw email stream: \n\n %@", responseObject);
        
        NSMutableDictionary* responseDict = responseObject;
        NSArray* raw = [responseDict objectForKey:@"messages"];
        
        NSLog(@"found %lu objects in email response.", [raw count]);

        NSMutableArray* emailArray = [[NSMutableArray alloc] init]; //temp

        
        for (int i = 0; i < [raw count]; ++i) {
            NSString* urlString = [NSString stringWithFormat:@"https://www.googleapis.com/gmail/v1/users/%@/messages/%@?&access_token=%@", user.userID, [[raw objectAtIndex:i] objectForKey:@"id"], user.accessToken];
            
            NSLog(@"making request for URL: %@", urlString);
            
            NSURL* requestURL = [NSURL URLWithString:urlString];
            NSURLRequest* request = [NSURLRequest requestWithURL:requestURL];
            NSURLResponse* resp = nil;
            NSError* error = nil;
            NSMutableDictionary* response = [NSJSONSerialization JSONObjectWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&error] options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"results for individual email: %@", response);
            
            NSString* body = @"";
            NSString* title = @"";
            NSString* sender = @"";
            
            NSArray* headers = [[response objectForKey:@"payload"] objectForKey:@"headers"];
            for (id c in headers) {
                if ([[c objectForKey:@"name"] isEqualToString:@"Subject"]) {
                    title = [c objectForKey:@"value"];
                } else if ([[c objectForKey:@"name"] isEqualToString:@"From"]){
                    sender = [c objectForKey:@"value"];
                }
            }
            
            NSLog(@"title of email: %@", title);
            NSLog(@"sender for mail: %@", sender);
            
            if ([[[response objectForKey:@"payload"] objectForKey:@"mimeType"] isEqualToString:@"multipart/related"]) {
                //do something
                NSLog(@"discovered form one");
                
                body = [[[[[[[response objectForKey:@"payload"] objectForKey:@"parts"] objectAtIndex:0] objectForKey:@"parts"] objectAtIndex:0] objectForKey:@"body"] objectForKey:@"data"];
            } else if ([[[response objectForKey:@"payload"] objectForKey:@"mimeType"] isEqualToString:@"multipart/alternative"]) {
                NSLog(@"discovered form two");
                
                body = [[[[[response objectForKey:@"payload"] objectForKey:@"parts"] objectAtIndex:0] objectForKey:@"body"] objectForKey:@"data"];
                
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

            
            if (![body isEqualToString:@""]) {
                FMEmail* email = [[FMEmail alloc] initWithTitle:title andBody:body andSender:sender andSummary:nil];
                [emailArray addObject:email];
            }

        }
        
        
        [self.delegate gotEmailForUser:emailArray];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // handle failure with delegate
        NSLog(@"fetching failed with error: \n\n %@", error);
        
    }];
    
    
    
    
}



@end

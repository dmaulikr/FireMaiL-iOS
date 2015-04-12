//
//  FMEmail.m
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import "FMEmail.h"

@implementation FMEmail

- (instancetype)initWithTitle:(NSString*)title andBody:(NSString*)body andSender:(NSString*)sender andSummary:(NSString *)summary{
    self.title = title;
    self.body = body;
    self.sender = sender;
    self.summary = summary;

    return self;
}

- (void)smartDetect{
    
    
    
}

@end

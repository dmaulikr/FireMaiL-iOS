//
//  FMEmail.m
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import "FMEmail.h"

@implementation FMEmail

- (instancetype)initWithTitle:(NSString*)title andBody:(NSString*)body andSender:(NSString*)sender{
    self.title = title;
    self.body = body;
    self.sender = sender;

    return self;
}

- (void)smartDetect{
    
    
    
}

@end

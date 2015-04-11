//
//  FMUser.h
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMUser : NSObject

@property (nonatomic, strong) NSString* userEmail;
@property (nonatomic, strong) NSString* netID;
@property (nonatomic, strong) NSString* accessToken;
@property (nonatomic, strong) NSString* userID;

@property (nonatomic, strong) NSMutableArray* emails;

- (instancetype)initWithGoogle;

@end

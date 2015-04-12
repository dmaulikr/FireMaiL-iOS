//
//  FMCommunicator.h
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMUser.h"

@protocol FMCommunicatorDelegate <NSObject>

- (void)gotEmailForUser:(NSMutableArray*)arrayOfEmailObjects;
- (void)fetchingEmailFailedWithError:(NSError*)error;

- (void)gotSummariesForUser:(NSMutableArray*)summaries;
- (void)fetchingSummariesFailedWithError:(NSError*)error;


@end

@interface FMCommunicator : NSObject

@property (nonatomic, weak) id<FMCommunicatorDelegate> delegate;

- (instancetype)initWithManager;

- (void)grabEmailForUser:(FMUser*)user;



@end

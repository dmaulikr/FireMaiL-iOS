//
//  FMMainViewController.h
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCommunicator.h"

@interface FMMainViewController : UIViewController <FMCommunicatorDelegate>

- (instancetype)initWithEmails:(NSMutableArray*)emails;


@end

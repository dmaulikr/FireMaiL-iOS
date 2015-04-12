//
//  FMEmail.h
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import <Foundation/Foundation.h>

//NS_ENUM(NSInteger, kEventType){
//    kEventTypeMeeting,
//    kEventTypeReminder,
//    kEventTypeShipment
//};

@protocol FMEmailDelegate <NSObject>

- (NSInteger)foundEventForDetect:(NSInteger)kEventTypeHandler;

@end

@interface FMEmail : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* body;
@property (strong, nonatomic) NSString* sender;

- (void)smartDetect;

- (instancetype)initWithTitle:(NSString*)title andBody:(NSString*)body andSender:(NSString*)sender;

@end

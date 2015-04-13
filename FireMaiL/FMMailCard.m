//
//  FMMailCard.m
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import "FMMailCard.h"
#import "FMEmail.h"
#import <QuartzCore/QuartzCore.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@implementation FMMailCard{
    FMEmail* mailObject;
    CGRect screen;
    CGRect originalFrame;
    
    UITextView* title;
    UITextView* body;
    
    UITapGestureRecognizer* tap;
    
    BOOL tapped;
    
}

- (instancetype)initWithMail:(FMEmail*)email{
    screen = [[UIScreen mainScreen] bounds];
    self = [super initWithFrame:screen];

    [self setFrame:screen];
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(amTap)];
    [self addGestureRecognizer:tap];
    tapped = NO;
    
    self.layer.cornerRadius = 10.0f;
    [self setClipsToBounds:NO];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(3, 3);
    self.layer.shadowRadius = 5;
    self.backgroundColor = [UIColor clearColor];
    
    UIView* rounded = [[UIView alloc] initWithFrame:self.frame];
    rounded.layer.cornerRadius = 10.0f;
    [rounded setClipsToBounds:YES];
    [self addSubview:rounded];
    
    mailObject = email;
    
    title = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 88)];
    [title setText:email.title];
    [title setBackgroundColor:UIColorFromRGB(0xA847A8)];
    [title setTextColor:[UIColor whiteColor]];
    [title setUserInteractionEnabled:NO];
//    [title setAdjustsFontSizeToFitWidth:YES];
    [rounded addSubview:title];
    
    
    body = [[UITextView alloc] initWithFrame:CGRectMake(0, title.frame.size.height, self.frame.size.width, self.frame.size.height-88)];
    [body setText:email.body];
    [body setBackgroundColor:UIColorFromRGB(0xA847A8)];
    [body setTextColor:[UIColor whiteColor]];
    [body setUserInteractionEnabled:NO];
    [rounded addSubview:body];
    
    [self setTransform:CGAffineTransformMakeScale(.85, .85)];
    
    originalFrame = self.frame;
    self.layer.shouldRasterize = YES;
    return self;
}

- (void)revertFrameTo:(CGRect)frame{
    [UIView animateWithDuration:0.2 animations:^{
        [self setFrame:frame];
        [self setTransform:CGAffineTransformMakeScale(.85, .85)];
        if (_rotationAngle > 0) {
//            self.transform = CGAffineTransformRotate(self.transform, -_rotationAngle);
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            [self setFrame:frame];
        } completion:^(BOOL finished) {
            NSLog(@"please work...");
        }];
        NSLog(@"que pasa???");
    }];
}

- (void)setEventType:(NSString*)eventType{
    _eventState = eventType;
}

- (void)sendConfirm{
    NSLog(@"performing action: %@", _eventState);
    NSLog(@"proof of concept limit break. -- at this point the app sends a request to the gmail server to either mark as read, or delete an email, open a controller to reply to the email, or create an event for the email.");
}

- (void)amTap{
    NSLog(@"detected tap on view!");
    if (tapped == NO) {
        tapped = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        [UIView animateWithDuration:0.4 animations:^{
            //
            [self setTransform:CGAffineTransformMakeScale(1, 1)];
//            [self setFrame:screen];

        } completion:^(BOOL finished) {
            //
        }];
    } else if (tapped == YES){
        tapped = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [UIView animateWithDuration:0.4 animations:^{
            //
//            [self setFrame:originalFrame];
            [self setTransform:CGAffineTransformMakeScale(.85, .85)];
        } completion:^(BOOL finished) {
            //
        }];
    }
}

- (void)animateOutWithType:(NSUInteger)type{
    
    //0 = event -- will generate event but not set as read. 
    //1 = read -- will set as read
    //2 = delete -- will do server post to gmail to set for delete
    //3 = reply -- this only does some animation crap

    switch (type) {
        case 0:
            //
            break;
            
        case 1:
            
            
            break;
            
        case 2:
            
            
            break;
            
        case 3:
            
            
            break;
            
        default:
            
            
            break;
    }
}

@end

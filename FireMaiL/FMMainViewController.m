//
//  FMMainViewController.m
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import "FMMainViewController.h"
#import "FMEmail.h"
#import "FMMailCard.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation FMMainViewController{
    
    UISwipeGestureRecognizer* read;
    UISwipeGestureRecognizer* smart;
    UISwipeGestureRecognizer* reply;
    UISwipeGestureRecognizer* delete;
    
    NSMutableArray* emailObjects;
    
    NSMutableArray* cards;
    
    NSMutableArray* swipedCards;
    
    UIButton* undo;
    
    UIButton* confirm;
}

- (instancetype)initWithEmails:(NSMutableArray*)emails{
    
    emailObjects = emails;
    cards = [[NSMutableArray alloc] init];
    swipedCards = [[NSMutableArray alloc] init];
    
    read = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setRead)];
    read.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.view addGestureRecognizer:read];
    
    smart = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setEvent)];
        smart.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:smart];
    
    reply = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setRespond)];
        reply.direction = UISwipeGestureRecognizerDirectionUp;
    
    [self.view addGestureRecognizer:reply];
    
    delete = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(setDelete)];
        delete.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:delete];
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:UIColorFromRGB(0xCC7ACC)];
    
    undo = [UIButton buttonWithType:UIButtonTypeCustom];
    [undo addTarget:self action:@selector(undo) forControlEvents:UIControlEventTouchUpInside];
    [undo setFrame:CGRectMake(22, 15, 30, 30)];
    [undo setBackgroundImage:[[UIImage imageNamed:@"back.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:normal];
    [undo setTintColor:[UIColor whiteColor]];
    [self.view addSubview:undo];
    
    confirm = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirm addTarget:self action:@selector(confirmActions) forControlEvents:UIControlEventTouchUpInside];
    [confirm setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width-52, 15, 30, 30)];
    [confirm setBackgroundImage:[[UIImage imageNamed:@"ok.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:normal];
    [confirm setTintColor:[UIColor whiteColor]];
    [self.view addSubview:confirm];
    
    for (int i = 0; i < [emailObjects count]; ++i) {
        FMMailCard* card = [[FMMailCard alloc] initWithMail:[emailObjects objectAtIndex:i]];
        
        [cards addObject:card];
        card.frame = CGRectOffset(card.frame, 0, 100);
        [card setAlpha:0.0];
        [self.view addSubview:card];
        [UIView animateWithDuration:0.6*i animations:^{
            card.frame = CGRectOffset(card.frame, 0, -100);
            [card setAlpha:1.0];
        } completion:^(BOOL finished) {
            NSLog(@"YEEEEEE");
        }];
    }
    
    BOOL testing = YES;
    
    if (testing) {
        NSLog(@"array contains %lu objects with: \n %@", [cards count], cards);
        [[cards objectAtIndex:0] removeFromSuperview];
        [cards removeObjectAtIndex:0];
        NSLog(@"array now has %lu objects: \n %@", [cards count], cards);
    }
    
}

- (void)setRead{
    NSLog(@"detected swipe left");
    [UIView animateWithDuration:0.4
                     animations:^{
                         [(FMMailCard*)[cards lastObject] setFrame:CGRectOffset([(FMMailCard*)[cards lastObject] frame], -200, 550)];
                         [(FMMailCard*)[cards lastObject] setTransform:CGAffineTransformMakeRotation(30)];
                         ((FMMailCard*)[cards lastObject]).rotationAngle = 30;
                     } completion:^(BOOL finished) {
                         //do something
                         [(FMMailCard*)[cards lastObject] setEventType:@"read"];
                         [swipedCards addObject:[cards lastObject]];
                         [[cards lastObject] removeFromSuperview];
                         [cards removeLastObject];
                     }];
}

- (void)setEvent{
    NSLog(@"detected swipe right");
    [UIView animateWithDuration:0.4
                     animations:^{
                         [(FMMailCard*)[cards lastObject] setFrame:CGRectOffset([(FMMailCard*)[cards lastObject] frame], 200, 550)];
                         
                         [(FMMailCard*)[cards lastObject] setTransform:CGAffineTransformMakeRotation(-30)];
                         ((FMMailCard*)[cards lastObject]).rotationAngle = -30;
                     } completion:^(BOOL finished) {
                         //do something
                         [(FMMailCard*)[cards lastObject] setEventType:@"event"];
                         
                         [swipedCards addObject:[cards lastObject]];
                         [[cards lastObject] removeFromSuperview];
                         [cards removeLastObject];
                     }];
}

- (void)setDelete{
    NSLog(@"detected swipe down");
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         [(FMMailCard*)[cards lastObject] setFrame:CGRectOffset([(FMMailCard*)[cards lastObject] frame], 0, 650)];

//                         [(FMMailCard*)[cards lastObject] setTransform:CGAffineTransformMakeRotation(30)];
                         ((FMMailCard*)[cards lastObject]).rotationAngle = 0;

                     } completion:^(BOOL finished) {
                         //do something
                         [(FMMailCard*)[cards lastObject] setEventType:@"delete"];

                         [swipedCards addObject:[cards lastObject]];
                         [[cards lastObject] removeFromSuperview];
                         [cards removeLastObject];
                     }];

}

- (void)setRespond{
    NSLog(@"detected swipe up");
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         [(FMMailCard*)[cards lastObject] setFrame:CGRectOffset([(FMMailCard*)[cards lastObject] frame], 0, -650)];
                         
//                         [(FMMailCard*)[cards lastObject] setTransform:CGAffineTransformMakeRotation(30)];
                         ((FMMailCard*)[cards lastObject]).rotationAngle = 0;
                     } completion:^(BOOL finished) {
                         //do something
                         [(FMMailCard*)[cards lastObject] setEventType:@"reply"];
                         [swipedCards addObject:[cards lastObject]];
                         [[cards lastObject] removeFromSuperview];
                         [cards removeLastObject];
                         [self.view bringSubviewToFront:undo];

                     }];

}

- (void)undo{
    [self.view setFrame:[[UIScreen mainScreen] bounds]];
    
    if ([swipedCards count] > 0) {
        [self.view addSubview:[swipedCards lastObject]];
        
//        [UIView animateWithDuration:0.4 animations:^{
//            [[swipedCards lastObject] setFrame:CGRectMake(0, 0, self.view.frame.size.width*.85, self.view.frame.size.height*.85)];//
//
////            [(FMMailCard*)[swipedCards lastObject] setTransform:CGAffineTransformMakeScale(.85, .85)];
//        } completion:^(BOOL finished) {
//            //
//            NSLog(@"idk what I'm doing");
//        }];
        
        [(FMMailCard*)[swipedCards lastObject] revertFrameTo:[[cards lastObject] frame]];
        
        [cards addObject:[swipedCards lastObject]];
        [swipedCards removeLastObject];
        [self.view bringSubviewToFront:undo];
        
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Well..." message:@"There's nothing to really undo yet soooooooo.... " delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
        [alert show];
        
    }
    

    
}

- (void)confirmActions{
    //handle the changes in teh server for what's happened so far.
    if ([swipedCards count] > 0) {
        NSMutableArray* responses = [[NSMutableArray alloc] init];
        
        for (FMMailCard* c in swipedCards) {
            [c sendConfirm];
            [responses addObject:[c eventState]];
        }
        
        if ([responses count] < 3) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Hi there" message:@"try playing around a bit more!" delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            NSString* finalString = [NSString stringWithFormat:@"you've reached the end of this proof of concept! The following actions for each of the emails you interacted with, would have been (this is only available for the first 3 in this demo): \n%@ \n%@ \n%@", [responses objectAtIndex:0], [responses objectAtIndex:1], [responses objectAtIndex:2]];
            
            UIAlertView* finale = [[UIAlertView alloc] initWithTitle:@"Yay!" message:finalString delegate:nil cancelButtonTitle:@"fin" otherButtonTitles:nil, nil];
            
            [finale show];
        }        
    }else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Bruh..." message:@"You haven't done anything yet... " delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil, nil];
        [alert show];
        
    }

    

    
    
}




@end

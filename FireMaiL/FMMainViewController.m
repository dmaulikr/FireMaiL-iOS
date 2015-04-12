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
                     } completion:^(BOOL finished) {
                         //do something
                     }];
}

- (void)setEvent{
    NSLog(@"detected swipe right");
    [UIView animateWithDuration:0.4
                     animations:^{
                         [(FMMailCard*)[cards lastObject] setFrame:CGRectOffset([(FMMailCard*)[cards lastObject] frame], 200, 550)];
                         
                         [(FMMailCard*)[cards lastObject] setTransform:CGAffineTransformMakeRotation(-30)];
                     } completion:^(BOOL finished) {
                         //do something
                     }];
}

- (void)setDelete{
    NSLog(@"detected swipe down");
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         [(FMMailCard*)[cards lastObject] setFrame:CGRectOffset([(FMMailCard*)[cards lastObject] frame], 0, 650)];

//                         [(FMMailCard*)[cards lastObject] setTransform:CGAffineTransformMakeRotation(30)];
                     } completion:^(BOOL finished) {
                         //do something
                         [swipedCards addObject:[cards lastObject]];
                         [cards removeLastObject];
                     }];

}

- (void)setRespond{
    NSLog(@"detected swipe up");
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         [(FMMailCard*)[cards lastObject] setFrame:CGRectOffset([(FMMailCard*)[cards lastObject] frame], 0, -650)];
                         
//                         [(FMMailCard*)[cards lastObject] setTransform:CGAffineTransformMakeRotation(30)];
                     } completion:^(BOOL finished) {
                         //do something
                     }];

}

- (void)undo{
    
    [(FMMailCard*)[swipedCards lastObject] revertFrame];
    
    [cards addObject:[swipedCards lastObject]];
    [swipedCards removeLastObject];
    
    
    
}




@end

//
//  FMMailCard.h
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import "FMEmail.h"



@interface FMMailCard : UIView

@property (nonatomic, strong) GPPSignInButton* signInButton;

- (instancetype)initWithMail:(FMEmail*)email;
- (void)revertFrame;

@end

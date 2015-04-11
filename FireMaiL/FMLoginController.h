//
//  FMLoginController.h
//  FireMaiL
//
//  Created by Rafi Rizwan on 4/11/15.
//  Copyright (c) 2015 POLYwhirl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface FMLoginController : UIViewController <GPPSignInDelegate>

@property (retain, nonatomic) GPPSignInButton* signInButton;

@end

//
//  SignUpControllerViewController.h
//  Nani
//
//  Created by Pawel Ferens on 1/22/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//
@protocol SignUpDelegate <NSObject>

@required

- (void)registrationCancelled;
- (void)registrationSuccededWithEmail:(NSString *)email
                          andPassword:(NSString *)password;

@end
#import <UIKit/UIKit.h>

@interface SignUpControllerViewController : UIViewController
@property (nonatomic, assign)id delegate;
@end

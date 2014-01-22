//
//  ViewController.m
//  Nani
//
//  Created by Pawel Ferens on 1/21/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UIView *blackOverlayView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginTextField.delegate = self;
    self.passwordTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moveUIElementsUpWithKeyboard
{
    [UIView animateWithDuration:0.3f animations:^{
        self.loginTextField.frame = CGRectMake(self.loginTextField.frame.origin.x,
                                               self.loginTextField.frame.origin.y-200,
                                               self.loginTextField.frame.size.width,
                                               self.loginTextField.frame.size.height);
        
        self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x,
                                                  self.passwordTextField.frame.origin.y-200,
                                                  self.passwordTextField.frame.size.width,
                                                  self.passwordTextField.frame.size.height);
        
        self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x,
                                            self.loginButton.frame.origin.y-200,
                                            self.loginButton.frame.size.width,
                                            self.loginButton.frame.size.height);
        
        self.blackOverlayView.alpha = 0.5f;
    }];
}

- (void)moveUIElementsDownWithKeyboard
{
    [UIView animateWithDuration:0.3f animations:^{
        self.loginTextField.frame = CGRectMake(self.loginTextField.frame.origin.x,
                                               self.loginTextField.frame.origin.y+200,
                                               self.loginTextField.frame.size.width,
                                               self.loginTextField.frame.size.height);
        
        self.passwordTextField.frame = CGRectMake(self.passwordTextField.frame.origin.x,
                                                  self.passwordTextField.frame.origin.y+200,
                                                  self.passwordTextField.frame.size.width,
                                                  self.passwordTextField.frame.size.height);
        
        self.loginButton.frame = CGRectMake(self.loginButton.frame.origin.x,
                                            self.loginButton.frame.origin.y+200,
                                            self.loginButton.frame.size.width,
                                            self.loginButton.frame.size.height);
        
        self.blackOverlayView.alpha = 0.0f;
    }];
}
#pragma mark -UIViewDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark -UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    [self moveUIElementsUpWithKeyboard];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self moveUIElementsDownWithKeyboard];
}
@end

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
bool isKeyboardMoved;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    self.loginTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    PFUser *user = [PFUser currentUser];
    if (user) {
        [self performSegueWithIdentifier:@"goToMainScreen" sender:self];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -Notification handlers
- (void)keyboardWillShow:(NSNotification *)notification
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

- (void)keyboardDidHide:(NSNotification *)notification
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == self.loginTextField) {
        [self.passwordTextField becomeFirstResponder];
    }
    else
    {
        [textField resignFirstResponder];
        
        [self performLoginWithEmail:self.loginTextField.text andPassword:self.passwordTextField.text];
    }
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier]isEqualToString:@"signUpSegue"]) {
        [[segue destinationViewController]setDelegate:self];
        

    }
    
    else if([[segue identifier]isEqualToString:@"goToMainScreen"])
    {
        
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"goToMainScreen"]) {
        [self performLoginWithEmail:self.loginTextField.text andPassword:self.passwordTextField.text];
        return NO;
    }
    return YES;
}
#pragma mark -SignUpDelegate

- (void)registrationCancelled
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)registrationSuccededWithEmail:(NSString *)email andPassword:(NSString *)password
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Registration succeded" message:@"Your confirmation email was sent. Please open email and activate your account. " delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];}


#pragma mark -Networking
- (void)performLoginWithEmail:(NSString *)email
                  andPassword:(NSString *)password
{
    [PFUser logInWithUsernameInBackground:email password:password block:^(PFUser *user, NSError *error) {
        
        if (user)
        {
           if( [[user objectForKey:@"emailVerified"] intValue] == YES)
           {
               
            [self performSegueWithIdentifier:@"goToMainScreen" sender:self];
               
           }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Login failed" message:@"Your account is not authenticated. Please open confirmation email and activate your accout" delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        else
        {
            NSString *errorString = [[error userInfo] objectForKey:@"error"];
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
    }];
}
@end

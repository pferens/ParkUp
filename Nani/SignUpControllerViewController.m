//
//  SignUpControllerViewController.m
//  Nani
//
//  Created by Pawel Ferens on 1/22/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import "SignUpControllerViewController.h"

@interface SignUpControllerViewController ()
- (IBAction)cancelAction:(id)sender;
- (IBAction)signUp:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignUpControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.view endEditing:YES];

}
#pragma mark -UIViewDelegate

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(registrationCancelled)]) {
        [self.delegate registrationCancelled];

    }
}

- (IBAction)signUp:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.emailTextField.text;
    user.password = self.passwordTextField.text;
    [user setObject:self.emailTextField.text forKey:@"email"];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            if ([self.delegate respondsToSelector:@selector(registrationSuccededWithEmail:andPassword:)]) {
                [self.delegate registrationSuccededWithEmail:self.emailTextField.text andPassword:self.passwordTextField.text];
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

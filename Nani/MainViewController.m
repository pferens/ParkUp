//
//  MainViewController.m
//  ParkUp
//
//  Created by Pawel Ferens on 1/23/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import "MainViewController.h"
#import "ConnectionManager.h"
#import "ContentManager.h"
#import "Day.h"
@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)NSDate *date;

- (IBAction)logOutButtonAction:(id)sender;

@end

@implementation MainViewController

int numberOfCards;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    numberOfCards = 0;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    self.date = [NSDate new];
    
    [[ConnectionManager sharedInstance]getSlotsWithCompletionBlock:^(BOOL success) {
        if (success) {
            numberOfCards = [ContentManager sharedInstance].slots.count;
            [[ConnectionManager sharedInstance]getDaysWithCompletionBlock:^(BOOL success) {
                [self.tableView reloadData];
            }];
        }
    }];
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [ContentManager sharedInstance].days.count;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    Day *day = [[ContentManager sharedInstance].days objectAtIndex:indexPath.row];

    NSCalendar *c = [NSCalendar currentCalendar];
    NSDateComponents* components = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:day.date];
    
    UILabel *numberLabel = (UILabel *)[cell viewWithTag:999];
    numberLabel.text = [NSString stringWithFormat:@"%d",[components day]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    
    UILabel *dayLabel = (UILabel *)[cell viewWithTag:998];
    dayLabel.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:day.date]];
    
    UIButton *button = (UIButton *)[cell viewWithTag:997];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"Reserve place" forState:UIControlStateNormal];

    for (PFObject *object in day.reservations) {
        
        if ([[[object objectForKey:@"user"]objectForKey:@"username"]isEqualToString:[PFUser currentUser].username]) {
            
            [button setTitle:@"Reserved" forState:UIControlStateNormal];

        }
        else if (day.reservations.count == [ContentManager sharedInstance].slots.count) {

                [button setTitle:@"All slots taken" forState:UIControlStateNormal];
            
        }


    }
    
    UIActivityIndicatorView *spinner =(UIActivityIndicatorView *)[cell viewWithTag:996];
    if (day.isEditing) {
        button.alpha = 0.0f;
        spinner.alpha = 1.0f;
        [spinner startAnimating];
    }
    else{
        button.alpha = 1.0f;
        spinner.alpha = 0.0f;
        [spinner stopAnimating];
    }
    return cell;
}

#pragma mark -Button actions

- (void)buttonTapped:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIActivityIndicatorView *spinner =(UIActivityIndicatorView *)[cell viewWithTag:996];
    UIButton *button = (UIButton *)[cell viewWithTag:997];
    button.alpha = 0.0f;
    spinner.alpha = 1.0f;
    [spinner startAnimating];
    
        bool shouldDoReservation = YES;
        if (indexPath != nil)
        {
            Day *day = [[ContentManager sharedInstance].days objectAtIndex:indexPath.row];
            day.isEditing = YES;
                for (PFObject *object in day.reservations) {
                    
                    if ([[[object objectForKey:@"user"]objectForKey:@"username"]isEqualToString:[PFUser currentUser].username]) {
                        
                        shouldDoReservation = NO;
                        [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            
                            button.alpha = 1.0f;
                            spinner.alpha = 0.0f;
                            [spinner stopAnimating];
                            day.isEditing = NO;

                            if (succeeded) {
                                NSLog(@"deleted");
                                [day.reservations removeObject:object];
                                
                                NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                                NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
                                [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];

                            }
                            else
                            {
                                NSLog(@"%@",[error description]);


                            }

                        }];
                    }

                }
            
            if (shouldDoReservation) {
                PFObject *reservation = [PFObject objectWithClassName:@"Slot_reservation"];
                [reservation setObject:day.date forKey:@"date"];
                
                [reservation setObject:[PFUser currentUser] forKey:@"user"];
                [reservation setObject:[[ContentManager sharedInstance].slots firstObject] forKey:@"slot"];
                [reservation saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    button.alpha = 1.0f;
                    spinner.alpha = 0.0f;
                    [spinner stopAnimating];
                    day.isEditing = NO;

                    
                    if (succeeded) {
                        
                        [[ConnectionManager sharedInstance]getDaysWithCompletionBlock:^(BOOL success) {
                            
                            NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                            NSArray* indexArray = [NSArray arrayWithObjects:indexPath1, nil];
                            [self.tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];

                        }];
                        
                    }
                    else
                    {
                        NSLog(@"%@",[error description]);

  
                    }
                    
                }];
            }

        }

}
- (IBAction)logOutButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

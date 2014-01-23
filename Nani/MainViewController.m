//
//  MainViewController.m
//  ParkUp
//
//  Created by Pawel Ferens on 1/23/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *park1Button;
@property (strong, nonatomic) IBOutlet UIButton *park2Button;
- (IBAction)logOutButtonAction:(id)sender;

@end

@implementation MainViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.navigationController.navigationBarHidden = NO;
    [self.navigationItem setHidesBackButton:YES animated:YES];

	// Do any additional setup after loading the view.
}


- (void)viewDidAppear:(BOOL)animated
{
    self.park1Button.backgroundColor = [UIColor redColor];
    self.park2Button.backgroundColor = [UIColor greenColor];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"dayCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    return cell;
}
- (IBAction)logOutButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end

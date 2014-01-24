//
//  CustomDayCell.h
//  ParkUp
//
//  Created by pferens on 24.01.2014.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDayCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dayNumber;
@property (weak, nonatomic) IBOutlet UILabel *dayName;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

//
//  ConnectionManager.m
//  ParkUp
//
//  Created by Pawel Ferens on 1/23/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import "ConnectionManager.h"
#import "ContentManager.h"
#import "Day.h"
@implementation ConnectionManager


+ (ConnectionManager *)sharedInstance
{
	static dispatch_once_t pred;
	static ConnectionManager *shared = nil;
	
	dispatch_once(&pred, ^{
		shared = [ConnectionManager new];
	});
	
	return shared;
}
- (void)getDaysWithCompletionBlock:(DownloadFileCallbackBlock)completionBlock
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Slot_reservation"];
    [query includeKey:@"user"];
    [query includeKey:@"slot"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [ContentManager sharedInstance].days = [[NSMutableArray alloc]init];

            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
            [comp setDay:1];
            [comp setHour:12];
            
            NSDate *firstDayOfMonthDate = [gregorian dateFromComponents:comp];
            
            NSCalendar *c = [NSCalendar currentCalendar];
            NSRange daysInMonth = [c rangeOfUnit:NSDayCalendarUnit
                                   inUnit:NSMonthCalendarUnit
                                  forDate:firstDayOfMonthDate];
            
            for(int i = 0; i < daysInMonth.length; i++)
            {
                NSDate *tempDate = [firstDayOfMonthDate dateByAddingTimeInterval:60*60*24*i];

                Day *day = [[Day alloc]init];
                day.date = tempDate;
                day.reservations = [[NSMutableArray alloc]init];
                
                NSCalendar *c = [NSCalendar currentCalendar];
                NSDateComponents* components;
                
                for (PFObject *res in objects) {
                    components = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:tempDate];
                    int actDay = [components day];
                    components = [c components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[res objectForKey:@"date"]];
                    int resDay = [components day];
                    if (actDay == resDay) {
                        [day.reservations addObject:res];
                    }
                }
                [[ContentManager sharedInstance].days addObject:day];
            }
            completionBlock(YES);
            
        }
        else {
            completionBlock(NO);
        }
    }];
}

- (void)getSlotsWithCompletionBlock:(DownloadFileCallbackBlock)completionBlock
{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Parking_slot"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [ContentManager sharedInstance].slots = [[NSMutableArray alloc]initWithArray:objects];
            
            completionBlock(YES);
            
        } else {
            completionBlock(NO);

        }
    }];
}



@end

//
//  Day.h
//  ParkUp
//
//  Created by Pawel Ferens on 1/24/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject
@property (nonatomic,strong)NSDate *date;
@property (nonatomic,strong)NSMutableArray *reservations;
@property (nonatomic)BOOL isEditing;
@end

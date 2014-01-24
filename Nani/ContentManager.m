//
//  ContentManager.m
//  ParkUp
//
//  Created by Pawel Ferens on 1/23/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import "ContentManager.h"
@implementation ContentManager


+ (ContentManager *)sharedInstance
{
    static ContentManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ContentManager alloc] init];
    });
    return sharedManager;
}


@end

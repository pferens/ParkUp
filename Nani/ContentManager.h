//
//  ContentManager.h
//  ParkUp
//
//  Created by Pawel Ferens on 1/23/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DownloadFileCallbackBlock)(BOOL success);

@interface ContentManager : NSObject

+ (ContentManager *)sharedInstance;

@property (nonatomic)NSMutableArray *days;
@property (nonatomic)NSMutableArray *slots;

@end

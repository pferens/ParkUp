//
//  ConnectionManager.h
//  ParkUp
//
//  Created by Pawel Ferens on 1/23/14.
//  Copyright (c) 2014 Pawel Ferens. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownloadFileCallbackBlock)(BOOL success);

@interface ConnectionManager : NSObject

+ (ConnectionManager *)sharedInstance;

- (void)getDaysWithCompletionBlock:(DownloadFileCallbackBlock)completionBlock;
- (void)getSlotsWithCompletionBlock:(DownloadFileCallbackBlock)completionBlock;
@end

//
//  VDDisplayItemProcessQueue.h
//  VDRangeController
//
//  Created by vedon on 7/5/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VDOperation;
@interface VDDisplayItemProcessQueue : NSObject

- (void)addOperation:(VDOperation *)operation;

- (void)removeAllOperations;

@end

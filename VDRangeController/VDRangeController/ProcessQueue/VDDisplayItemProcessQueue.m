//
//  VDDisplayItemProcessQueue.m
//  VDRangeController
//
//  Created by vedon on 7/5/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDDisplayItemProcessQueue.h"
#import "VDOperation.h"
#import "VDAssert.h"

@interface VDDisplayItemProcessQueue ()
@property (strong,nonatomic) NSOperationQueue *_queue;
@end

@implementation VDDisplayItemProcessQueue

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)addOperation:(VDOperation *)operation
{
    VDAssert(operation != nil,@"Operation can not be nil");
    if (operation)
    {
        [self._queue addOperation:operation];
    }
}

- (void)removeAllOperations
{
    [self._queue cancelAllOperations];
}

#pragma mark - Getter & Setter

- (NSOperationQueue *)_queue
{
    if (!__queue)
    {
        __queue = [[NSOperationQueue alloc] init];
        __queue.name = @"com.VDDisplayItemProcessQueue";
        NSUInteger maximumConcurrentOperationCount = [NSProcessInfo processInfo].activeProcessorCount * 4;
        __queue.maxConcurrentOperationCount = maximumConcurrentOperationCount;
        
        if ([__queue respondsToSelector:@selector(setQualityOfService:)])
        {
            [__queue setQualityOfService:NSQualityOfServiceUserInitiated];
        }
    }
    
    return __queue;
}

@end

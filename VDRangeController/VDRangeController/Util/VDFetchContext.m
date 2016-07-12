//
//  VDFetchContext.m
//  VDRangeController
//
//  Created by vedon on 7/2/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDFetchContext.h"

typedef NS_ENUM(NSUInteger,VDFetchContextState)
{
    VDFetchContextState_Fetching,
    VDFetchContextState_Cancelled,
    VDFetchContextState_Completed,
};

@interface VDFetchContext ()
@property (strong,nonatomic) NSRecursiveLock *_internalLock;
@property (assign,nonatomic) VDFetchContextState _contextState;

@end

@implementation VDFetchContext

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self._internalLock = [[NSRecursiveLock alloc] init];
        self._contextState = VDFetchContextState_Completed;
    }
    return self;
}

- (BOOL)isFetching
{
    [self._internalLock lock];
    BOOL isFetching = (self._contextState == VDFetchContextState_Fetching);
    [self._internalLock unlock];
    
    return isFetching;
}

- (BOOL)didCancelFetching
{
    [self._internalLock lock];
    BOOL isCancelFetching = (self._contextState == VDFetchContextState_Cancelled);
    [self._internalLock unlock];
    
    return isCancelFetching;
}

- (void)beginFetching
{
    [self._internalLock lock];
    self._contextState = VDFetchContextState_Fetching;
    [self._internalLock unlock];
}

- (void)completeFetching
{
    [self._internalLock lock];
    self._contextState = VDFetchContextState_Completed;
    [self._internalLock unlock];
}

- (void)cancelFetching
{
    [self._internalLock lock];
    self._contextState = VDFetchContextState_Cancelled;
    [self._internalLock unlock];
}

@end

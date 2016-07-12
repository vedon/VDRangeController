//
//  VDCallbackBlockWrapper.m
//  MainThreadSentinel
//
//  Created by vedon on 6/27/16.
//  Copyright © 2016 vedon. All rights reserved.
//

#import "VDCallbackBlockWrapper.h"

@interface VDCallbackBlockWrapper ()
@property (nonatomic,copy) VDCallbackWrapperBlock _internalCallbackBlock;
@end

@implementation VDCallbackBlockWrapper

- (instancetype)initWithBlock:(VDCallbackWrapperBlock)callbackBlock
{
    self = [super init];
    if (self)
    {
        self._internalCallbackBlock = callbackBlock;
    }
    return self;
}

#pragma mark - VDCallbackObjectProtocol

- (void)doSomethingToWakeUpMainRunLoop
{
    if (self._internalCallbackBlock)
    {
        self._internalCallbackBlock();
        self._internalCallbackBlock = nil;
    }
}

@end
